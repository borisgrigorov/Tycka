final List<TestType> predefinedTestTypes = [
  TestType(
      "LP6464-4", "Nucleic acid amplification with probe detection", "PCR"),
  TestType("LP217198-3", "Rapid immunoassay", "AG"),
];

final List<TestResult> predefinedTestResults = [
  TestResult("260415000", "Negative"),
  TestResult("260373001", "Positive"),
];

class TestType {
  String name;
  String code;
  String aka;
  TestType(this.code, this.name, this.aka);
}

class TestResult {
  String code;
  String name;
  TestResult(this.code, this.name);
}
