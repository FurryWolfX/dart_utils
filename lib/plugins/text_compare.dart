import 'dart:math';

/// 计算文本相似度(余弦相似度)
///
/// 余弦相似度用向量空间中两个向量夹角的余弦值作为衡量两个个体差异的大小。
/// 余弦值越接近1，就表明夹角越接近0度，也就是两个向量越相似，这就是余弦相似性。
double getTextSimilarity(String doc1, String doc2) {
  if (doc1.isEmpty && doc2.isEmpty) {
    return 1;
  }
  if (doc1.isEmpty || doc2.isEmpty) {
    return 0;
  }
  Map<String, List<int>> algMap = {};
  for (int i = 0; i < doc1.length; i++) {
    String d1 = doc1[i];
    List<int>? fq = algMap[d1];
    if (fq != null && fq.length == 2) {
      fq[0]++;
    } else {
      fq = [1, 0];
      algMap[d1] = fq;
    }
  }
  for (int i = 0; i < doc2.length; i++) {
    String d2 = doc2[i];
    List<int>? fq = algMap[d2];
    if (fq != null && fq.length == 2) {
      fq[1]++;
    } else {
      fq = [0, 1];
      algMap[d2] = fq;
    }
  }
  double sqdoc1 = 0;
  double sqdoc2 = 0;
  double denuminator = 0;
  for (var entry in algMap.entries) {
    List<int> c = entry.value;
    denuminator += c[0] * c[1];
    sqdoc1 += c[0] * c[0];
    sqdoc2 += c[1] * c[1];
  }
  return denuminator / sqrt(sqdoc1 * sqdoc2);
}

/// 计算文本相似度(集合法)
double getTextBalance(String doc1, String doc2) {
  if (doc1.isEmpty && doc2.isEmpty) {
    return 1;
  }
  if (doc1.isEmpty || doc2.isEmpty) {
    return 0;
  }
  Set<String> doc1Set = doc1.split('').toSet();
  Set<String> doc2Set = doc2.split('').toSet();
  // 交集数量
  int intersection = doc1Set.intersection(doc2Set).length;
  if (intersection == 0) {
    return 0;
  }
  int union = doc1Set.union(doc2Set).length;
  double d = intersection / union;
  return d;
}
