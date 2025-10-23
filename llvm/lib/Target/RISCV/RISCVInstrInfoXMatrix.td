//===-- RISCVInstrInfoXMatrix.td ---------------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the matrix vendor extensions.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// MEMORY INSTRUCTIONS
//===----------------------------------------------------------------------===//

class MatrixInstLoad<string opcodestr, string argstr, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;
  bits<5> rs2;

  let Inst{31-25} = 0b0010000;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b100;
  let Inst{11-7}  = md;
  let Inst{6-0}   = OPC_CUSTOM_3.Value;
}

let Predicates = [HasVendorXMatrix], hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
  def MLS : MatrixInstLoad<"mls", "$md, $rs1, $rs2",
                           (outs MR:$md), (ins GPRMemZeroOffset:$rs1, GPR:$rs2)>;
}

class MatrixInstStore<string opcodestr, string argstr, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> ms3;
  bits<5> rs1;
  bits<5> rs2;

  let Inst{31-25} = 0b0010000;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b101;
  let Inst{11-7}  = ms3;
  let Inst{6-0}   = OPC_CUSTOM_3.Value;
}

let Predicates = [HasVendorXMatrix], hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
  def MSS : MatrixInstStore<"mss", "$ms3, $rs1, $rs2",
                            (outs), (ins MR:$ms3, GPRMemZeroOffset:$rs1, GPR:$rs2)>;
}

//===----------------------------------------------------------------------===//
// ARITHMETIC INSTRUCTIONS
//===----------------------------------------------------------------------===//

class MatrixAluFunct3<bits<3> value> {
  bits<3> Value = value;
}
def MMacFunct3 : MatrixAluFunct3<0b000>;
def MAddFunct3 : MatrixAluFunct3<0b001>;

class MatrixDataType<bits<2> value> {
  bits<2> Value = value;
}
def MUnsigned : MatrixDataType<0b00>;
def MSigned   : MatrixDataType<0b01>;
def MFloat    : MatrixDataType<0b10>;

class MatrixInstAluBase<string opcodestr, string argstr, MatrixAluFunct3 funct3, MatrixDataType dt, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> ms1;
  bits<5> ms2;

  let Inst{31-28} = 0b0110;
  let Inst{27-26} = dt.Value;
  let Inst{25}    = 0b0;
  let Inst{24-20} = ms2;
  let Inst{19-15} = ms1;
  let Inst{14-12} = funct3.Value;
  let Inst{11-7}  = md;
  let Inst{6-0}   = OPC_CUSTOM_3.Value;
}

class MatrixInstAlu<string opcodestr, MatrixAluFunct3 funct3, MatrixDataType dt>
    : MatrixInstAluBase<opcodestr, "$md, $ms1, $ms2", funct3, dt,
                        (outs MR:$md), (ins MR:$ms1, MR:$ms2)>;

multiclass MatrixInstAlu_SUF<string opcodestr, MatrixAluFunct3 funct3> {
  def S : MatrixInstAlu<opcodestr, funct3, MUnsigned>;
  def U : MatrixInstAlu<opcodestr, funct3, MSigned>;
  def F : MatrixInstAlu<opcodestr, funct3, MFloat>;
}

let Predicates = [HasVendorXMatrix], hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  defm MADD : MatrixInstAlu_SUF<"madd", MAddFunct3>;
  defm MMAC : MatrixInstAlu_SUF<"mmac", MMacFunct3>;
}

//===----------------------------------------------------------------------===//
// MOVEMENT INSTRUCTIONS
//===----------------------------------------------------------------------===//

class MatrixInstMov<string opcodestr, string argstr, dag outs, dag ins>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> md;
  bits<5> rs1;

  let Inst{31-20} = 0b010000100001;
  let Inst{19-15} = rs1;
  let Inst{14-12} = 0b000;
  let Inst{11-7}  = md;
  let Inst{6-0}   = OPC_CUSTOM_3.Value;
}

let Predicates = [HasVendorXMatrix] in {
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
    def MMV_XM : MatrixInstMov<"mmv.xm", "$md, $rs1", (outs MR:$md), (ins GPR:$rs1)>;
  }
  def : InstAlias<"mzero $md", (MMV_XM MR:$md, X0)>;
}
