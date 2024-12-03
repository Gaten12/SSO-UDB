import '../data/mahasiswa.dart';
import '../data/mata_kuliah.dart';
import '../data/nilai.dart';
import 'ipk_kalkulator.dart';

void cetakDaftarMahasiswa(List<Mahasiswa> daftarMahasiswa) {
  print('\nDaftar Mahasiswa:');
  for (var mahasiswa in daftarMahasiswa) {
    print('- ${mahasiswa.nim}: ${mahasiswa.nama}');
  }
}

void cetakKRS(Mahasiswa mahasiswa, List<MataKuliah> daftarMataKuliah) {
  print('\nKRS Mahasiswa:');
  print('NIM: ${mahasiswa.nim}');
  print('Nama: ${mahasiswa.nama}');
  print('Semester: ${mahasiswa.semester}');
  print('\nDaftar Mata Kuliah:');
  for (var mk in daftarMataKuliah) {
    print('- ${mk.nama} (${mk.kode}, ${mk.sks} SKS)');
  }
}

void cetakTranskripNilai(List<Mahasiswa> daftarMahasiswa,
    Map<String, List<Nilai>> nilaiPerMahasiswa) {
  print('\nTranskrip Nilai Mahasiswa:');
  for (var mahasiswa in daftarMahasiswa) {
    print('\nMahasiswa: ${mahasiswa.nama} (${mahasiswa.nim})');
    var daftarNilai = nilaiPerMahasiswa[mahasiswa.nim];
    if (daftarNilai == null || daftarNilai.isEmpty) {
      print('  Belum ada nilai.');
      continue;
    }

    for (var nilai in daftarNilai) {
      String grade = scoreToGrade(nilai.nilai);
      print(
          '  Mata Kuliah: ${nilai.mataKuliah.nama}, SKS: ${nilai.mataKuliah.sks}, Nilai: $grade');
    }
  }
}
