import 'dart:io';

import 'data/mahasiswa.dart';
import 'data/mata_kuliah.dart';
import 'data/nilai.dart';
import 'sistem/ipk_kalkulator.dart';
import 'sistem/printer.dart';

void main() {
  List<Mahasiswa> daftarMahasiswa = [];
  Map<String, List<MataKuliah>> mataKuliahPerMahasiswa = {};
  Map<String, List<Nilai>> nilaiPerMahasiswa = {};

  while (true) {
    print('\n===+++ SSO UDB BETA +++===');
    print('1. Input Data Mahasiswa');
    print('2. Input Mata Kuliah');
    print('3. Input Nilai Mahasiswa');
    print('4. Hitung IPK');
    print('5. Cetak KRS');
    print('6. Transkrip Nilai');
    print('7. Keluar');
    print('++++++++++++++++++++++++++');
    stdout.write('Pilih menu: ');
    var pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        stdout.write('Masukkan NIM: ');
        String nim = stdin.readLineSync() ?? '';
        stdout.write('Masukkan Nama: ');
        String nama = stdin.readLineSync() ?? '';
        stdout.write('Masukkan Semester: ');
        int semester = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

        var mahasiswa = Mahasiswa(nim, nama, semester);
        daftarMahasiswa.add(mahasiswa);
        mataKuliahPerMahasiswa[nim] = [];
        nilaiPerMahasiswa[nim] = [];
        print('Mahasiswa berhasil ditambahkan.');
        break;

      case '2':
        if (daftarMahasiswa.isEmpty) {
          print(
              'Belum ada data mahasiswa. Tambahkan mahasiswa terlebih dahulu.');
          break;
        }

        cetakDaftarMahasiswa(daftarMahasiswa);
        stdout.write('Pilih NIM mahasiswa: ');
        String nim = stdin.readLineSync() ?? '';

        var mahasiswa = daftarMahasiswa.firstWhere(
          (m) => m.nim == nim,
          orElse: () => Mahasiswa('', '', 0),
        );

        if (mahasiswa.nim.isEmpty) {
          print('Mahasiswa tidak ditemukan.');
          break;
        }

        stdout.write('Masukkan Kode Mata Kuliah: ');
        String kode = stdin.readLineSync() ?? '';
        stdout.write('Masukkan Nama Mata Kuliah: ');
        String namaMK = stdin.readLineSync() ?? '';
        stdout.write('Masukkan Jumlah SKS (1-3): ');
        int sks = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

        if (sks < 1 || sks > 3) {
          print('SKS harus antara 1 hingga 3.');
          break;
        }

        var mataKuliah = MataKuliah(kode, namaMK, sks);
        mataKuliahPerMahasiswa[nim]?.add(mataKuliah);
        print('Mata kuliah berhasil ditambahkan.');
        break;

      case '3':
        if (daftarMahasiswa.isEmpty) {
          print(
              'Belum ada data mahasiswa. Tambahkan mahasiswa terlebih dahulu.');
          break;
        }

        cetakDaftarMahasiswa(daftarMahasiswa);
        stdout.write('Pilih NIM mahasiswa: ');
        String nim = stdin.readLineSync() ?? '';

        var mataKuliahList = mataKuliahPerMahasiswa[nim];
        if (mataKuliahList == null || mataKuliahList.isEmpty) {
          print('Mahasiswa ini belum memiliki mata kuliah.');
          break;
        }

        print('\nDaftar Mata Kuliah:');
        for (var mk in mataKuliahList) {
          print('- ${mk.kode}: ${mk.nama} (${mk.sks} SKS)');
        }

        for (var mk in mataKuliahList) {
          stdout.write(
              'Masukkan nilai untuk ${mk.nama} (${mk.kode}) (A/B/C/D/E): ');
          String grade = stdin.readLineSync()?.toUpperCase() ?? '';
          double nilai = gradeToScore(grade);

          if (nilai < 0) {
            print('Nilai tidak valid.');
            continue;
          }

          nilaiPerMahasiswa[nim]
              ?.removeWhere((n) => n.mataKuliah.kode == mk.kode);
          nilaiPerMahasiswa[nim]?.add(Nilai(mk, nilai));
        }
        print('Nilai berhasil diinput.');
        break;

      case '4':
        cetakDaftarMahasiswa(daftarMahasiswa);
        stdout.write('Pilih NIM mahasiswa: ');
        String nim = stdin.readLineSync() ?? '';

        var daftarNilai = nilaiPerMahasiswa[nim];
        if (daftarNilai == null || daftarNilai.isEmpty) {
          print('Mahasiswa ini belum memiliki nilai.');
          break;
        }

        double ipk = hitungIPK(daftarNilai);
        print('IPK Mahasiswa: ${ipk.toStringAsFixed(2)}');
        break;

      case '5':
        cetakDaftarMahasiswa(daftarMahasiswa);
        stdout.write('Pilih NIM mahasiswa: ');
        String nim = stdin.readLineSync() ?? '';

        var mahasiswa = daftarMahasiswa.firstWhere(
          (m) => m.nim == nim,
          orElse: () => Mahasiswa('', '', 0),
        );

        if (mahasiswa.nim.isEmpty) {
          print('Mahasiswa tidak ditemukan.');
          break;
        }

        var mataKuliahList = mataKuliahPerMahasiswa[nim];
        if (mataKuliahList == null || mataKuliahList.isEmpty) {
          print('Mahasiswa ini belum memiliki mata kuliah.');
          break;
        }

        cetakKRS(mahasiswa, mataKuliahList);
        break;

      case '6':
        cetakTranskripNilai(daftarMahasiswa, nilaiPerMahasiswa);
        break;

      case '7':
        print('Keluar dari program...');
        return;

      default:
        print('Pilihan tidak valid.');
    }
  }
}
