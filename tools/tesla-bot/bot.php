<?php
declare(strict_types=1);

/*
 * Tesla kullanılmış araç ilanı takip botu.
 *
 * Sayfayı belirli aralıklarla indirir, içindeki araç kimliklerini (VIN) çıkarır,
 * daha önce görülmemiş olanlar varsa ntfy.sh üzerinden bildirim gönderir.
 *
 * Kullanım:  php bot.php [--dump]
 *   --dump   Son alınan HTML'i last.html olarak kaydeder (hata ayıklama için).
 *
 * Ortam değişkenleri:
 *   NTFY_TOPIC  Bildirim konusu (ntfy.sh). Yeni ilan olduğunda buraya gönderilir.
 *   STATE_FILE  Görülen ilanların saklandığı dosya (varsayılan: tools/tesla-bot/state.json)
 *   TESLA_URL   Kontrol edilecek adres (varsayılan: aşağıdaki sabit)
 *   NTFY_URL    ntfy sunucusu (varsayılan: https://ntfy.sh)
 */

const DEFAULT_URL = 'https://www.tesla.com/tr_TR/inventory/used/my?arrangeby=plh&zip=35550&range=0';
const USER_AGENT  = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36';

function env(string $name, string $default = ''): string
{
    $value = getenv($name);
    return ($value === false || $value === '') ? $default : $value;
}

function httpRequest(string $url, array $options = []): string
{
    $ch = curl_init($url);
    curl_setopt_array($ch, $options + [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_TIMEOUT        => 60,
        CURLOPT_USERAGENT      => USER_AGENT,
    ]);
    $body = curl_exec($ch);
    $code = (int) curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
    $err  = curl_error($ch);
    curl_close($ch);

    if ($body === false) {
        throw new RuntimeException("İstek başarısız: $url ($err)");
    }
    if ($code < 200 || $code >= 300) {
        throw new RuntimeException("HTTP $code döndü: $url");
    }
    return $body;
}

/**
 * Sayfadaki VIN benzeri 17 karakterlik kimlikleri çıkarır.
 * VIN'de I, O, Q harfleri bulunmaz; hem harf hem rakam içermesi gerekir.
 *
 * @return string[]
 */
function extractListings(string $html): array
{
    preg_match_all('/\b[A-HJ-NPR-Z0-9]{17}\b/', $html, $matches);

    $vins = [];
    foreach ($matches[0] as $token) {
        if (preg_match('/[A-Z]/', $token) && preg_match('/[0-9]/', $token)) {
            $vins[$token] = true;
        }
    }
    return array_keys($vins);
}

function loadState(string $file): array
{
    if (!is_file($file)) {
        return [];
    }
    $data = json_decode((string) file_get_contents($file), true);
    return is_array($data['seen'] ?? null) ? $data['seen'] : [];
}

function saveState(string $file, array $seen): void
{
    $json = json_encode(
        ['seen' => array_values($seen), 'checked_at' => date(DATE_ATOM)],
        JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
    );
    file_put_contents($file, $json . "\n");
}

function notify(string $server, string $topic, string $message, string $clickUrl): void
{
    // Başlık ASCII olmalı: HTTP başlıkları UTF-8 kabul etmez.
    httpRequest(rtrim($server, '/') . '/' . rawurlencode($topic), [
        CURLOPT_POST       => true,
        CURLOPT_POSTFIELDS => $message,
        CURLOPT_HTTPHEADER => [
            'Title: Tesla - yeni ilan',
            'Click: ' . $clickUrl,
            'Priority: high',
            'Tags: car',
        ],
    ]);
}

function main(array $argv): int
{
    $url       = env('TESLA_URL', DEFAULT_URL);
    $topic     = env('NTFY_TOPIC');
    $server    = env('NTFY_URL', 'https://ntfy.sh');
    $stateFile = env('STATE_FILE', __DIR__ . '/state.json');

    try {
        $html = httpRequest($url, [
            CURLOPT_HTTPHEADER => ['Accept: text/html', 'Accept-Language: tr-TR,tr;q=0.9'],
        ]);

        if (in_array('--dump', $argv, true)) {
            file_put_contents(__DIR__ . '/last.html', $html);
        }

        $current = extractListings($html);
        $seen    = loadState($stateFile);
        $new     = array_values(array_diff($current, $seen));

        echo sprintf("%d ilan bulundu, %d yeni.\n", count($current), count($new));

        if ($new !== []) {
            if ($topic === '') {
                throw new RuntimeException('Yeni ilan var ama NTFY_TOPIC tanımlı değil.');
            }
            $message = "Yeni ilan: " . count($new) . " adet\n" . implode("\n", array_slice($new, 0, 10));
            notify($server, $topic, $message, $url);
        }

        // Bildirim başarılı olduktan sonra kaydet; böylece başarısız bildirim bir sonraki çalışmada tekrar denenir.
        saveState($stateFile, $current);
        return 0;
    } catch (Throwable $e) {
        fwrite(STDERR, '[' . date(DATE_ATOM) . '] Hata: ' . $e->getMessage() . "\n");
        return 1;
    }
}

exit(main($argv));
