enum FilterType{


  all(title: "Hepsi"),
  done(title: "Tamamlandı"),
  undone(title: "Tamamlanmadı");



  final String title;

  const FilterType({required this.title});




}