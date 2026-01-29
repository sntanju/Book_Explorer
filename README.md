# 📚 Book Explorer App  
A clean-architecture Flutter application that allows users to search, explore, and view details of books using the **Open Library API**.

<p align="center">
  <img src="assets/app_banner.png" width="600" />
</p>

<p align="center">
  <img src="https://github.com/sntanju/Book_Explorer/blob/78d48ce3042fcac2f6ecc618397a49ba99c95121/assets/images/bookImage.jpg" width="600" />
</p>


---

## 🎥 Demo Video  
👉 Coming soon…

<p align="center">
  <a href="https://www.youtube.com/watch?v=VIDEO_ID">
    <img src="https://img.youtube.com/vi/VIDEO_ID/0.jpg" width="500" />
  </a>
</p>


---

## ⭐ Features

- 🔍 **Powerful book search** (title, author, keywords)
- 📖 **View detailed information** of each book  
- 🗂 **Browse books by subject / category**
- 🖼 **High-quality cover images (Open Library Cover API)**
- 🎛 **Client-side filters** (Author, Year)
- 🧱 **Clean Architecture**
  - Interface → Repository → Provider → UI

---

## 🏗 Clean Architecture Overview

```
lib/
│
├── core/
│   ├── api/                 # Network interceptor, Dio config
│   └── widgets/             # Shared widgets (image loader, etc.)
│
├── data/
│   ├── interfaces/          # Abstract repository interfaces
│   ├── models/              # Data models
│   └── repository/          # Repository implementations
│
├── presentation/
│   ├── provider/            # State management (Provider)
│   └── screens/             # UI Screens
│
└── main.dart
```

---

## 🔧 Tech Stack

| Layer | Technology |
|------|------------|
| UI | Flutter, Material 3 |
| State Management | Provider |
| Networking | Dio |
| API | Open Library API |
| Architecture | Clean, modular |

---

## 📡 APIs Used

### 🔹 Search API  
https://openlibrary.org/search.json?q={query}&page={page}

### 🔹 Subject Books API  
https://openlibrary.org/subjects/{subject}.json

### 🔹 Work Details API  
https://openlibrary.org/works/OL123W.json

### 🔹 Cover Images  
https://covers.openlibrary.org/b/id/{coverId}-L.jpg

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/sntanju/Book_Explorer.git
cd Book_Explorer
```

## 2️⃣ Install Dependencies
```sh
flutter pub get
```

### 3️⃣ Run the App
```sh
flutter run
```




