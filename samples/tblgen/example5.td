class Car<string model, string color> {
  string Model = model;
  string Color = color;
}

foreach Index = !range(0, 3, 1) in {
  def Car # Index : Car<"Model " # Index, "black">;
}
