within OpenIPSL.Examples;
package SunnyHighPowerInverter
  extends Modelica.Icons.ExamplesPackage;

  model AlsetLabInverter
    extends Modelica.Icons.Example;
    Electrical.Renewables.PSSE.PV pV(
      V_b=600,
      P_0(displayUnit="W") = 2877.062,
      Q_0(displayUnit="V.A") = 945.6242,
      QFunctionality=1,
      redeclare OpenIPSL.Electrical.Renewables.PSSE.InverterInterface.REGCA1
        RenewableGenerator,
      redeclare OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.REECB1
        RenewableController,
      redeclare OpenIPSL.Electrical.Renewables.PSSE.PlantController.REPCA1
        PlantController)
      annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
    Electrical.Buses.Bus InverterBus(V_b=600)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Electrical.Branches.PSSE.TwoWindingTransformer twoWindingTransformer(
      R=0,
      X=113.33,
      G=0,
      B=0,
      VNOM1(displayUnit="V") = 600,                                      VB1(
          displayUnit="V") = 600, VNOM2(displayUnit="V") = 480,
      VB2(displayUnit="V") = 480)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    Electrical.Buses.Bus GridBus(V_b=480)
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Electrical.Machines.PSSE.GENCLS INF(V_b=480, P_0(displayUnit="W"))
      annotation (Placement(transformation(extent={{70,20},{50,40}})));
    Electrical.Renewables.PSSE.PV pV1(
      V_b=600,
      P_0(displayUnit="W") = 2877.062,
      Q_0(displayUnit="V.A") = 945.6242,
      QFunctionality=1,
      redeclare Electrical.Renewables.PSSE.InverterInterface.REGCA1
        RenewableGenerator,
      redeclare Electrical.Renewables.PSSE.ElectricalController.REECB1
        RenewableController,
      redeclare Electrical.Renewables.PSSE.PlantController.REPCA1
        PlantController)
      annotation (Placement(transformation(extent={{-84,-40},{-64,-20}})));
    Electrical.Buses.Bus InverterBus1(V_b=600)
      annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));
    Electrical.Branches.PSSE.TwoWindingTransformer twoWindingTransformer1(
      R=0,
      X=113.33,
      G=0,
      B=0,
      VNOM1(displayUnit="V") = 600,
      VB1(displayUnit="V") = 600,
      VNOM2(displayUnit="V") = 480,
      VB2(displayUnit="V") = 480)
      annotation (Placement(transformation(extent={{-24,-40},{-4,-20}})));
    Electrical.Buses.Bus GridBus1(V_b=480)
      annotation (Placement(transformation(extent={{6,-40},{26,-20}})));
    Electrical.Sources.VoltageSourceReImInput voltageSourceReImInput
      annotation (Placement(transformation(extent={{56,-40},{36,-20}})));
    Modelica.Blocks.Sources.RealExpression VR(y=if time < 5 then INF.p.vr else
          INF.p.vr*0.9)
      annotation (Placement(transformation(extent={{82,-28},{68,-12}})));
    Modelica.Blocks.Sources.RealExpression VI(y=INF.p.vi)
      annotation (Placement(transformation(extent={{82,-48},{68,-32}})));
    inner Electrical.SystemBase          SysData(fn=60, S_b=100000000) annotation (Placement(transformation(extent={{-88,74},
              {-48,94}})));
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
      annotation (Line(points={{-64,-30},{-44,-30}}, color={0,0,255}));
    connect(InverterBus1.p, twoWindingTransformer1.p)
      annotation (Line(points={{-44,-30},{-25,-30}}, color={0,0,255}));
    connect(twoWindingTransformer1.n, GridBus1.p)
      annotation (Line(points={{-3,-30},{16,-30}}, color={0,0,255}));
    connect(voltageSourceReImInput.p, GridBus1.p)
      annotation (Line(points={{35,-30},{16,-30}}, color={0,0,255}));
    connect(VR.y, voltageSourceReImInput.vRe) annotation (Line(points={{67.3,
            -20},{64,-20},{64,-26},{58,-26}}, color={0,0,127}));
    connect(VI.y, voltageSourceReImInput.vIm) annotation (Line(points={{67.3,
            -40},{64,-40},{64,-34},{58,-34}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end AlsetLabInverter;
end SunnyHighPowerInverter;
