# Tanem Nyak

**Tanem Nyak** adalah game simulasi pertanian (farming sim) yang dikembangkan dengan Godot Engine.

## Pendiri & Pengembang
**Muhammad Ikhsan** — Teknik Informatika, Universitas Pamulang

- Email: ican3192@gmail.com
- Instagram: [@ikhsan2.1](https://instagram.com/ikhsan2.1)
- GitHub: [NASHKITWO](https://github.com/NASHKITWO)

## Kredit
Proyek ini dibangun di atas basis kode open-source "farmer-game" (lihat bagian di bawah dan berkas `LICENSE.md`).

---

## Tentang basis proyek (farmer-game)
This game is inspired by Maxis's SimFarm (1993). However, it has the ambition of being more realistic both in agronomic and in a financial way. That means that I am trying to create a model for a crop that responds to the environment (soil, weather, diseases, fertilizers, pesticides, hydric stress, etc) and also a model for the economic system where you have to buy and sell in a very competitive market. For the first version, I will focus on coffee crops. I had to do this because, in the level of realism that I am trying to achieve for the crop models, two different cultivars have very different logic behaviors. However, I'm trying to structure it in such a way that it can be easily extensible for other crop models. 

It's the first time I´m using the Godot engine, and it's the first time I´m making a game from scratch at all. So I am pretty sure that it will have a lot of issues in logic and performance at first, which I will try to address while developing the game core.

Godot is a wonderful open-source game engine, written in C++ and in GodotScript, which allows you to create games using a GUI and codes in GodotScript (python-like) or C#. It is also possible to write code in C++ and integrate it with Godot. I don't know how to do it yet, but it is something that I surely will do to solve some performance and code cleanness issues: Instantiating many crops at the same time is currently taking to long; Godot Script has a week OOP structure, and I'm missing Interfaces and Abstract Classes very much, which I believe will be a problem when I try to add other cultivars beside coffee.

If you want to contribute to this game, you can understand how its working now by the diagrams on the [Coffee Crop Model](docs/crop-model-coffe.md) document.
All that functionality is implemented in the [Crop.gd script](crop/Crop.gd)

[Coffee Crop Model](docs/crop-model-coffe.md) (currently in portuguese).

---

## Android / layar sentuh
Di perangkat sentuh, kontrol di layar muncul otomatis (di desktop tekan **T** untuk menampilkan/menyembunyikan):
- Kiri bawah: D-pad (geser kamera) dan tombol **+ / −** (zoom)
- Kanan bawah: mode **Tanam, Penyakit, Sebar, Pantau** dan tombol **Siklus**
- Ketuk/seret di peta = klik kiri (pilih item di panel kanan atas, lalu ketuk peta untuk menanam)

Export: Godot 3.5 → Project > Install Android Build Template, lalu Project > Export > Android.
