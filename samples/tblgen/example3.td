class Car<string model, string color> {
  string Model = model;
  string Color = color;
}

multiclass ColoredCar<string model> {
  def Black : Car<model, "black">;
  def White : Car<model, "white">;
}

defm Brasilia : ColoredCar<"Brasilia">;
defm Kombi    : ColoredCar<"Kombi">;
defm Fusca    : ColoredCar<"Fusca">;
