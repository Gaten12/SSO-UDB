import '../data/nilai.dart';

double hitungIPK(List<Nilai> daftarNilai) {
  double totalNilai = 0;
  int totalSKS = 0;

  for (var nilai in daftarNilai) {
    totalNilai += nilai.nilai * nilai.mataKuliah.sks;
    totalSKS += nilai.mataKuliah.sks;
  }

  return totalSKS > 0 ? totalNilai / totalSKS : 0.0;
}

double gradeToScore(String grade) {
  switch (grade) {
    case 'A':
      return 4.0;
    case 'B':
      return 3.0;
    case 'C':
      return 2.0;
    case 'D':
      return 1.0;
    case 'E':
      return 0.0;
    default:
      return -1.0;
  }
}

String scoreToGrade(double score) {
  if (score >= 4.0) return 'A';
  if (score >= 3.0) return 'B';
  if (score >= 2.0) return 'C';
  if (score >= 1.0) return 'D';
  return 'E';
}
