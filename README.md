🚀 How to Run This Flutter App
📥 1. Clone the project
bash
คัดลอก
แก้ไข
git clone https://github.com/your-username/music_playlist_app.git
cd music_playlist_app
🔁 เปลี่ยน URL ให้เป็นของ repo จริงถ้าคุณอัปโหลดขึ้น GitHub แล้ว

⚙️ 2. Install dependencies
bash
คัดลอก
แก้ไข
flutter pub get
🏃 3. Run the app
bash
คัดลอก
แก้ไข
flutter run
คุณสามารถรันได้ทั้งบน emulator หรือ device จริง

⚠️ ปัญหาที่อาจเกิดขึ้น: รันแอปไม่ผ่าน
หากคุณเจอปัญหาเกี่ยวกับ build หรือ error ที่เกิดจาก Gradle เช่น:

การตั้งค่า JVM หรือ locale ที่ไม่ตรง

การโหลด Gradle failed โดยไม่มีสาเหตุชัดเจน

ให้ตรวจสอบไฟล์ android/gradle.properties และตรวจสอบว่ามีการตั้งค่าดังนี้:

properties
คัดลอก
แก้ไข
org.gradle.jvmargs=-Xmx1536m -Duser.country=US -Duser.language=en
หากไม่มีหรือค่าต่างจากนี้:

👉 แนะนำให้สร้างโปรเจค Flutter ใหม่ (เช่น flutter create dummy_app) แล้วคัดลอกค่าจากไฟล์ gradle.properties ของโปรเจคนั้นมาแทนที่ของโปรเจคนี้

🧰 Resources
Flutter Official Documentation

Install Flutter SDK

Flutter Codelab

