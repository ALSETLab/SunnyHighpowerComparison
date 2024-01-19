within OpenIPSL.Examples;
package SunnyHighPowerInverter
  extends Modelica.Icons.ExamplesPackage;

  model AlsetLabInverter
    extends Modelica.Icons.Example;
    Electrical.Renewables.PSSE.PV pV(
      V_b=352.01,
      P_0(displayUnit="W") = 2877.062,
      Q_0(displayUnit="V.A") = 80,
      QFunctionality=1,
      redeclare OpenIPSL.Electrical.Renewables.PSSE.InverterInterface.REGCA1
        RenewableGenerator,
      redeclare OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.REECB1
        RenewableController(
        Kqp=0.01,
        Kqi=0.2,
        Kvp=1,
        Kvi=0),
      redeclare OpenIPSL.Electrical.Renewables.PSSE.PlantController.REPCA1
        PlantController)
      annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
    Electrical.Buses.Bus InverterBus(V_b=352.01)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Electrical.Branches.PSSE.TwoWindingTransformer twoWindingTransformer(
      R=0,
      X=0.034,
      G=0,
      B=0,
      VNOM1(displayUnit="V") = 352.01,                                   VB1(
          displayUnit="V") = 600,
      VNOM2(displayUnit="V") = 281.61,
      VB2(displayUnit="V") = 480)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    Electrical.Buses.Bus GridBus(V_b=281.61)
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Electrical.Machines.PSSE.GENCLS INF(
      V_b=281.61,                                   P_0(displayUnit="W"),
      X_d=0)
      annotation (Placement(transformation(extent={{70,20},{50,40}})));
    Electrical.Renewables.PSSE.PV pV1(
      V_b=352.01,
      P_0(displayUnit="W") = 2877.062,
      Q_0(displayUnit="V.A") = 80,
      QFunctionality=1,
      redeclare Electrical.Renewables.PSSE.InverterInterface.REGCA1
        RenewableGenerator,
      redeclare Electrical.Renewables.PSSE.ElectricalController.REECB1
        RenewableController(
        Kqp=0.01,
        Kqi=0.2,
        Kvp=1,
        Kvi=0),
      redeclare Electrical.Renewables.PSSE.PlantController.REPCA1
        PlantController)
      annotation (Placement(transformation(extent={{-94,-40},{-74,-20}})));
    Electrical.Buses.Bus InverterBus1(V_b=352.01)
      annotation (Placement(transformation(extent={{-64,-40},{-44,-20}})));
    Electrical.Branches.PSSE.TwoWindingTransformer twoWindingTransformer1(
      R=0,
      X=0.034,
      G=0,
      B=0,
      VNOM1(displayUnit="V") = 352.01,
      VB1(displayUnit="V") = 600,
      VNOM2(displayUnit="V") = 281.61,
      VB2(displayUnit="V") = 480)
      annotation (Placement(transformation(extent={{-34,-40},{-14,-20}})));
    Electrical.Buses.Bus GridBus1(V_b=281.61)
      annotation (Placement(transformation(extent={{-4,-40},{16,-20}})));
    Electrical.Sources.VoltageSourceReImInput voltageSourceReImInput(V_b=281.61)
      annotation (Placement(transformation(extent={{66,-40},{46,-20}})));
    Modelica.Blocks.Sources.RealExpression VR(y=if time < 5 then INF.p.vr else
          INF.p.vr*0.9737)
      annotation (Placement(transformation(extent={{92,-28},{78,-12}})));
    Modelica.Blocks.Sources.RealExpression VI(y=INF.p.vi)
      annotation (Placement(transformation(extent={{92,-48},{78,-32}})));
    inner Electrical.SystemBase          SysData(fn=60, S_b(displayUnit="V.A") = 30000)
                                                                       annotation (Placement(transformation(extent={{-88,74},
              {-48,94}})));
    Electrical.Branches.PwLine pwLine(
      R=0.000001,
      X=0.000001,
      G=0,
      B=0) annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
    Electrical.Buses.Bus GridBus2(V_b=281.61)
      annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
    Modelica.Blocks.Math.Acos acos
      annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
    Modelica.Blocks.Sources.RealExpression VI1(y=pwLine.is.im/pwLine.is.re)
      annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  equation
    connect(pV.pwPin, InverterBus.p)
      annotation (Line(points={{-50,30},{-30,30}}, color={0,0,255}));
    connect(InverterBus.p, twoWindingTransformer.p)
      annotation (Line(points={{-30,30},{-11,30}}, color={0,0,255}));
    connect(twoWindingTransformer.n, GridBus.p)
      annotation (Line(points={{11,30},{30,30}}, color={0,0,255}));
    connect(GridBus.p, INF.p)
      annotation (Line(points={{30,30},{50,30}}, color={0,0,255}));
    connect(pV1.pwPin, InverterBus1.p)
      annotation (Line(points={{-74,-30},{-54,-30}}, color={0,0,255}));
    connect(InverterBus1.p, twoWindingTransformer1.p)
      annotation (Line(points={{-54,-30},{-35,-30}}, color={0,0,255}));
    connect(twoWindingTransformer1.n, GridBus1.p)
      annotation (Line(points={{-13,-30},{6,-30}}, color={0,0,255}));
    connect(VR.y, voltageSourceReImInput.vRe) annotation (Line(points={{77.3,
            -20},{74,-20},{74,-26},{68,-26}}, color={0,0,127}));
    connect(VI.y, voltageSourceReImInput.vIm) annotation (Line(points={{77.3,
            -40},{74,-40},{74,-34},{68,-34}}, color={0,0,127}));
    connect(GridBus1.p, pwLine.p)
      annotation (Line(points={{6,-30},{11,-30}}, color={0,0,255}));
    connect(pwLine.n, GridBus2.p)
      annotation (Line(points={{29,-30},{36,-30}}, color={0,0,255}));
    connect(GridBus2.p, voltageSourceReImInput.p)
      annotation (Line(points={{36,-30},{45,-30}}, color={0,0,255}));
    connect(VI1.y, acos.u)
      annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end AlsetLabInverter;
end SunnyHighPowerInverter;
