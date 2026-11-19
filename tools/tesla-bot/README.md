# Tesla kullanılmış araç ilan botu

`https://www.tesla.com/tr_TR/inventory/used/my?arrangeby=plh&zip=35550&range=0` adresini
periyodik olarak kontrol eder. Daha önce görülmemiş bir ilan çıkarsa telefonuna
bildirim gönderir.

## Nasıl çalışır

1. Sayfayı indirir.
2. Sayfadaki 17 karakterlik araç kimliklerini (VIN) çıkarır.
3. `state.json` içindeki önceki listeyle karşılaştırır.
4. Yeni ilan varsa [ntfy.sh](https://ntfy.sh) üzerinden bildirim gönderir.
5. Bildirim başarılıysa listeyi `state.json`a kaydeder. Bildirim başarısızsa kaydetmez,
   böylece bir sonraki çalışmada tekrar dener.

## Telefona bildirim kurulumu (ücretsiz, hesap gerektirmez)

1. Telefonuna **ntfy** uygulamasını yükle (Android / iOS).
2. Uygulamada rastgele, tahmin edilmesi zor bir konu adı seç, örn. `tesla-ilan-x7k2q9`.
   Bu konu adı bir gizli anahtar gibi davranır, herkese açık paylaşma.
3. GitHub deposunda **Settings → Secrets and variables → Actions → New repository secret**
   ile `NTFY_TOPIC` adında bir secret ekle ve değerine konu adını yaz.

Bildirimin tıklanınca doğrudan Tesla sayfası açılır.

## Çalıştırma

GitHub Actions (önerilen): `.github/workflows/tesla-inventory.yml` her 15 dakikada bir
çalışır. GitHub zamanlanmış çalışmaları yalnızca varsayılan dalda (default branch)
işletir; bu yüzden iş akışı bu dal birleştirildikten sonra devreye girer. Elle denemek
için Actions sekmesinden **Run workflow** düğmesini kullanabilirsin.

Kendi bilgisayarında veya sunucunda (PHP 8+ ve curl eklentisi gerekir):

```bash
NTFY_TOPIC=tesla-ilan-x7k2q9 php tools/tesla-bot/bot.php
```

Cron örneği (her 15 dakikada bir):

```
*/15 * * * * NTFY_TOPIC=tesla-ilan-x7k2q9 php /yol/tools/tesla-bot/bot.php >> /var/log/tesla-bot.log 2>&1
```

Hata ayıklama: `php tools/tesla-bot/bot.php --dump` komutu son sayfayı `last.html` olarak kaydeder.

## Bilinen sınırlamalar

- Tesla'nın sitesi ilanları JavaScript ile yüklüyor olabilir. Bot yalnızca sunucudan gelen
  HTML'i okur. Sayfa boş dönerse ilan bulunamaz; `--dump` ile HTML'i kontrol et.
- Tesla bot isteklerini engelleyebilir (HTTP 403). Bu durumda bot hata verir ve GitHub
  Actions çalışmayı başarısız olarak işaretler; ilan kontrolü yapılamamış olur.
- Ayrıştırma VIN benzeri 17 karakterlik dizilere dayanır. Sayfadaki başka bir kod da
  bu biçime uyarsa yanlış bildirim gelebilir.
- Gerçek Tesla sayfasıyla uçtan uca test edilmedi (aşağıya bak).
