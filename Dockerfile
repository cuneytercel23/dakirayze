FROM node:16-alpine as builder 
WORKDIR '/app'
COPY  package.json . 
RUN npm install
COPY . .
RUN npm run build

# builder isim olarak biz verdik nginx'i kullanarak ondan copyalama yapıcaz.

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html


# Yukarıda build phasede bütün işlemler yapıldı..
# Daha sonra nginx sadece gerekli olan build klasörünü /app/build adresinden alıp , /usr/share/nginx/html buradaki kendi adresine ekledi.
# Daha sonra docker build . yaptık. imagemiz oluştu.
# Ondan sonra da docker run -p 3000:80(default nginx portu 80) <image-id> yaptık ve programımız çalıştı.


##Dockerfile.dev ile sadece development modunda görüntü oluşturabiliyoruz.
##Production modu için bu Dockerfile kullanıcaz. yukardaki komutlar bittikten sonra da, en aşağıdaki run ile yeni bir build klasörü oluşacak.
## Daha sonra nginx kullanarak bu oluşturulan build dosyasının sonuçlarını sunucaz yani çalıştırıcaz gibi.
## yukarıdaki build phase bittikten sonra, nginx çalıştırıcaz. nginx'de diğer commandlerin hepsini boşverip sadece npm run buildde oluşan klasörü copylayacak ve kendisi çalıştırıcak.


##alakasız bilgi
## he bu arada dosyalardaki build klasörü,  normal terminalde npm run build yapınca kendi kendisine oluşturuluyor.
## npm run build ile Esasen, tüm JavaScript dosyalarını alır, hepsini birlikte işler, hepsini tek bir dosyada(build klasörü) bir araya getirir



## Normalde travis.yaml dosyasından sonra bitiyordu tüm işlemler ama, travis portu alamıyormuş o yüzden expose 80 diye gösterdik.
