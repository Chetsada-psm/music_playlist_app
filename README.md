
# 🎵 Music Playlist App

A Flutter project for a simple music playlist application.

---

## 🚀 How to Run This Flutter App

### 📥 1. Clone the project

```bash
git clone https://github.com/Chetsada-psm/music_playlist_app.git
cd music_playlist_app
```


---

### ⚙️ 2. Install dependencies

```bash
flutter pub get
```

---

### 🏃 3. Run the app

```bash
flutter run
```

> ✅ รองรับการรันทั้งบน emulator หรือ physical device

---

### ⚠️ ปัญหาที่อาจเกิดขึ้น: รันแอปไม่ผ่าน

หากคุณเจอปัญหา build error จาก Gradle (เช่น locale ผิด หรือ JVM arguments ไม่ตรง), ให้ตรวจสอบไฟล์ `android/gradle.properties` ว่ามีบรรทัดนี้:

```properties
org.gradle.jvmargs=-Xmx1536m -Duser.country=US -Duser.language=en
```

ถ้าไม่มี หรือไม่เหมือน:

👉 **แนะนำให้สร้างโปรเจค Flutter ใหม่** (ใช้คำสั่ง `flutter create dummy_app`) แล้วคัดลอกค่าจากไฟล์ `gradle.properties` ของโปรเจคนั้นมาใส่ในโปรเจคนี้แทน

---

### 🧰 Resources

- [Flutter Official Documentation](https://flutter.dev/docs)
- [Install Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Flutter Codelab](https://flutter.dev/docs/get-started/codelab)
