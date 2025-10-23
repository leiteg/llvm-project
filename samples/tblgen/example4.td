class Car<string model, string color> {
  string Model = model;
  string Color = color;
  string Manufacturer = ?;
}

multiclass ColoredCar<string model> {
  def Black : Car<model, "black">;
  def White : Car<model, "white">;
}

let Manufacturer = "VW" in {
  defm Brasilia : ColoredCar<"Brasilia">;
  defm Kombi    : ColoredCar<"Kombi">;
  defm Fusca    : ColoredCar<"Fusca">;
}
