within OpenIPSL.Electrical.Renewables.PSSE;
model PV_with_inputs_FOR_PAPER2
  "Framework for a photovoltaic plant including controllers"
parameter Types.ApparentPower M_b=RenewableGenerator.SysData.S_b "Machine base power" annotation(Dialog(group= "Power flow data"));
extends OpenIPSL.Electrical.Essentials.pfComponent(
    final enablefn=false,
    final enableV_b=false,
    final enableangle_0=true,
    final enablev_0=true,
    final enableQ_0=true,
    final enableP_0=true,
    final enabledisplayPF=true,
    final enableS_b=true);

  // Parameters for selection
  parameter Integer QFunctionality = 0 "BESS Reactive Power Control Options" annotation (Dialog(group= "Reactive Power Control Options"), choices(choice=0 "Constant local PF control", choice=1 "Constant local Q control", choice=2 "Local V control", choice=3 "Local coordinated V/Q control", choice=4 "Plant level Q control", choice=5 "Plant level V control", choice=6 "Plant level Q control + local coordinated V/Q control", choice=7 "Plant level V control + local coordinated V/Q control"));
  parameter Integer PFunctionality = 0 "BESS Real Power Control Options" annotation (Dialog(group= "Active Power Control Options", enable=(QFunctionality >=4)), choices(choice=0 "No governor response", choice=1 "Governor response with up and down regulation"));

  // Irradiance to Power parameter selection
  parameter Boolean Irr2Pow = false "Irradiance to Power Options" annotation (Dialog(group= "Irradiance to Power Add-On Capability"));

  // External Qref
  parameter Boolean QrefExt = false "Enable external Qref" annotation (Dialog(group= "External Qref Capability"));
  replaceable
    OpenIPSL.Electrical.Renewables.PSSE.InverterInterface.BaseClasses.BaseREGC
    RenewableGenerator(
    M_b=M_b,
    P_0=P_0,
    Q_0=Q_0,
    v_0=v_0,
    angle_0=angle_0) annotation (choicesAllMatching=true, Placement(
        transformation(extent={{40,-20},{80,20}})));
  replaceable
    OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.BaseClasses.BaseREECB
    RenewableController(
    pfflag=pfflag,
    vflag=vflag,
    qflag=qflag,
    pqflag=false) annotation (choicesAllMatching=true, Placement(transformation(
          extent={{-12,-20},{28,20}})));
  Interfaces.PwPin pwPin
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable
    OpenIPSL.Electrical.Renewables.PSSE.PlantController.BaseClasses.BaseREPC
    PlantController(
    M_b=M_b,
    P_0=P_0,
    Q_0=Q_0,
    v_0=v_0,
    angle_0=angle_0,
    fflag=fflag,
    refflag=refflag) if QFunctionality >= 4 annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-76,-20},{-36,20}})));
  Modelica.Blocks.Math.Gain Pref_REEC(k=1) if QFunctionality < 4 and not
    Irr2Pow annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={38,-62})));
  Modelica.Blocks.Math.Gain Qref_REEC(k=1) if QFunctionality < 4 and not
    QrefExt annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={38,-54})));
  Modelica.Blocks.Interfaces.RealInput FREQ if QFunctionality >= 4
    "Connection Point Frequency"
    annotation (Placement(transformation(extent={{-120,-42},{-100,-22}}),
        iconTransformation(extent={{-120,-42},{-100,-22}})));

  Modelica.Blocks.Interfaces.RealInput branch_ir if QFunctionality >= 4 "Measured Branch Real Current"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-82,56}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-100})));
  Modelica.Blocks.Interfaces.RealInput branch_ii if QFunctionality >= 4 "Measured Branch Imaginary Current"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-64,56}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100})));
  Modelica.Blocks.Interfaces.RealInput regulate_vr if QFunctionality >= 4 "Regulated Branch Real Voltage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,56}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-56,66})));
  Modelica.Blocks.Interfaces.RealInput regulate_vi if QFunctionality >= 4 "Regulated Branch Imaginary Voltage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,56}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,100})));
  Modelica.Blocks.Interfaces.RealInput Pinput if Irr2Pow
    "Irradiance to Power input" annotation (Placement(transformation(extent={{-120,-6},
            {-100,14}}),     iconTransformation(extent={{-120,-6},{-100,14}})));
  Modelica.Blocks.Math.Gain IN_Pref_REEC(k=1) if Irr2Pow and QFunctionality < 4
    annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=0,
        origin={-90,26})));
  Modelica.Blocks.Math.Gain IN_Pref_REPC(k=1) if Irr2Pow and QFunctionality >=
    4 annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=0,
        origin={-90,4})));
  Modelica.Blocks.Math.Gain Pref_REPC(k=1)
    if QFunctionality >= 4 and not Irr2Pow annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={38,-46})));
  Modelica.Blocks.Interfaces.RealInput Qinput if QrefExt
    "Irradiance to Power input" annotation (Placement(transformation(extent={{-120,26},
            {-100,46}}),      iconTransformation(extent={{-120,26},{-100,46}})));
  Modelica.Blocks.Math.Gain IN_Qref_REEC(k=1) if QrefExt and QFunctionality < 4
    annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=0,
        origin={-90,36})));
  Modelica.Blocks.Math.Gain IN_Qref_REPC(k=1) if QrefExt and QFunctionality >=
    4 annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=0,
        origin={-90,16})));
  Modelica.Blocks.Math.Gain Qref_REPC(k=1)
    if QFunctionality >= 4 and not QrefExt annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={38,-38})));
  Modelica.Blocks.Sources.RealExpression freq_ref(y=SysData.fn)
    annotation (Placement(transformation(extent={{-60,-32},{-74,-44}})));
protected
      parameter Boolean pfflag = (if QFunctionality == 0 then true else false);
      parameter Boolean vflag = (if QFunctionality == 3 or QFunctionality == 6 or QFunctionality == 7 then true else false);
      parameter Boolean qflag = (if QFunctionality == 2 or QFunctionality == 3 or QFunctionality == 6 or QFunctionality == 7 then true else false);
      parameter Boolean refflag = (if QFunctionality == 5 or QFunctionality == 7 then true else false);
      parameter Boolean fflag = (if PFunctionality == 1 then true else false);
equation

P0 = RenewableGenerator.p_0;
Q0 = RenewableGenerator.q_0;

  connect(RenewableGenerator.IQ0, RenewableController.iq0) annotation (Line(
        points={{42.8571,-21.4286},{42.8571,-24},{24,-24},{24,-21.3333}},
        color={0,0,127}));
  connect(RenewableGenerator.IP0, RenewableController.ip0) annotation (Line(
        points={{51.4286,-21.4286},{51.4286,-26},{16,-26},{16,-21.3333}},
                                                                        color=
         {0,0,127}));
  connect(RenewableGenerator.V_0, RenewableController.v0) annotation (Line(
        points={{60,-21.4286},{60,-28},{8,-28},{8,-21.3333}}, color={0,0,127}));
  connect(RenewableGenerator.V_t, RenewableController.Vt) annotation (Line(
        points={{48.5714,21.4286},{48.5714,26},{-18,26},{-18,10.6667},{-13.3333,
          10.6667}}, color={0,0,127}));
  connect(RenewableGenerator.Pgen, RenewableController.Pe) annotation (Line(
        points={{60,21.4286},{60,28},{-20,28},{-20,5.33333},{-13.3333,5.33333}},
        color={0,0,127}));
  connect(RenewableGenerator.Qgen, RenewableController.Qgen) annotation (Line(
        points={{71.4286,21.4286},{71.4286,30},{-22,30},{-22,0},{-13.3333,0}},
        color={0,0,127}));
  connect(RenewableGenerator.p, pwPin)
    annotation (Line(points={{80,0},{100,0}}, color={0,0,255}));
  connect(PlantController.branch_ir, branch_ir) annotation (Line(points={{-70,22},
          {-70,44},{-82,44},{-82,56}},     color={0,0,127}));
  connect(PlantController.regulate_vi, regulate_vi) annotation (Line(points={{-42,22},
          {-42,44},{-30,44},{-30,56}},   color={0,0,127}));
  connect(IN_Pref_REEC.y, RenewableController.Pref) annotation (Line(points={{
          -87.8,26},{-28,26},{-28,-10.6667},{-13.3333,-10.6667}}, color={0,0,
          127}));
  connect(Pref_REPC.u, RenewableGenerator.p_0) annotation (Line(points={{40.4,
          -46},{77.1429,-46},{77.1429,-21.4286}}, color={0,0,127}));
  connect(IN_Qref_REPC.u, Qinput) annotation (Line(points={{-92.4,16},{-96,16},
          {-96,36},{-110,36}}, color={0,0,127}));
  connect(Pref_REEC.u, RenewableGenerator.p_0) annotation (Line(points={{40.4,
          -62},{77.1429,-62},{77.1429,-21.4286}}, color={0,0,127}));
  connect(Qref_REEC.u, RenewableGenerator.q_0) annotation (Line(points={{40.4,
          -54},{68.5714,-54},{68.5714,-21.4286}}, color={0,0,127}));
  connect(Qref_REPC.u, RenewableGenerator.q_0) annotation (Line(points={{40.4,
          -38},{68.5714,-38},{68.5714,-21.4286}}, color={0,0,127}));
  connect(PlantController.p0, RenewableGenerator.p_0) annotation (Line(points={
          {-70,-22},{-70,-32},{77.1429,-32},{77.1429,-21.4286}}, color={0,0,127}));
  connect(PlantController.q0, RenewableGenerator.q_0) annotation (Line(points={
          {-56,-22},{-56,-30},{68.5714,-30},{68.5714,-21.4286}}, color={0,0,127}));
  connect(PlantController.v0, RenewableGenerator.V_0) annotation (Line(points={
          {-42,-22},{-42,-28},{60,-28},{60,-21.4286}}, color={0,0,127}));
  connect(RenewableController.Ipcmd, RenewableGenerator.Ipcmd) annotation (Line(
        points={{28.6667,-11.3333},{28,-11.4286},{37.1429,-11.4286}}, color={0,
          0,127}));
  connect(RenewableController.Iqcmd, RenewableGenerator.Iqcmd) annotation (Line(
        points={{28.6667,11.3333},{28,11.4286},{37.1429,11.4286}}, color={0,0,
          127}));
  connect(RenewableController.p0, RenewableGenerator.p_0) annotation (Line(
        points={{-8,-21.3333},{-8,-32},{77.143,-32},{77.143,-21.4286},{77.1429,
          -21.4286}}, color={0,0,127}));
  connect(RenewableController.q0, RenewableGenerator.q_0) annotation (Line(
        points={{0,-21.3333},{0,-30},{68.5714,-30},{68.5714,-21.4286}}, color={
          0,0,127}));
  connect(Qref_REEC.y, RenewableController.Qext) annotation (Line(points={{35.8,
          -54},{-18,-54},{-18,-5.33333},{-13.3333,-5.33333}}, color={0,0,127}));
  connect(Pref_REEC.y, RenewableController.Pref) annotation (Line(points={{35.8,
          -62},{-20,-62},{-20,-10.6667},{-13.3333,-10.6667}}, color={0,0,127}));
  connect(freq_ref.y, PlantController.Freq_ref) annotation (Line(points={{-74.7,
          -38},{-80,-38},{-80,-12},{-78,-12}}, color={0,0,127}));
  connect(IN_Qref_REEC.y, RenewableController.Qext) annotation (Line(points={{
          -87.8,36},{-26,36},{-26,-5.33333},{-13.3333,-5.33333}}, color={0,0,
          127}));
  connect(PlantController.Qext, RenewableController.Qext) annotation (Line(
        points={{-35,10},{-26,10},{-26,-5.33333},{-13.3333,-5.33333}}, color={0,
          0,127}));
  connect(PlantController.Pref, RenewableController.Pref) annotation (Line(
        points={{-35,-10.6},{-26,-10.6},{-26,-10.6667},{-13.3333,-10.6667},{
          -13.3333,-10.6667}}, color={0,0,127}));
  connect(Pinput, IN_Pref_REPC.u)
    annotation (Line(points={{-110,4},{-92.4,4}}, color={0,0,127}));
  connect(IN_Pref_REPC.y, PlantController.Plant_pref)
    annotation (Line(points={{-87.8,4},{-78,4}}, color={0,0,127}));
  connect(IN_Qref_REPC.y, PlantController.Qref) annotation (Line(points={{-87.8,
          16},{-82,16},{-82,12},{-78,12}}, color={0,0,127}));
  connect(FREQ, PlantController.Freq) annotation (Line(points={{-110,-32},{-94,
          -32},{-94,-4},{-78,-4}}, color={0,0,127}));
  connect(IN_Qref_REEC.u, Qinput)
    annotation (Line(points={{-92.4,36},{-110,36}}, color={0,0,127}));
  connect(IN_Pref_REEC.u, Pinput) annotation (Line(points={{-92.4,26},{-98,26},
          {-98,4},{-110,4}}, color={0,0,127}));
  connect(Pref_REPC.y, PlantController.Plant_pref) annotation (Line(points={{
          35.8,-46},{-82,-46},{-82,4},{-78,4}}, color={0,0,127}));
  connect(Qref_REPC.y, PlantController.Qref) annotation (Line(points={{35.8,-38},
          {28,-38},{28,-66},{-84,-66},{-84,12},{-78,12}}, color={0,0,127}));
  connect(branch_ii, PlantController.branch_ii) annotation (Line(points={{-64,
          56},{-64,44},{-60,44},{-60,22}}, color={0,0,127}));
  connect(regulate_vr, PlantController.regulate_vr) annotation (Line(points={{
          -46,56},{-46,44},{-50,44},{-50,22}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-120,-80},{120,80}}),
                   graphics={      Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
                         Text(
          extent={{-40,20},{40,-20}},
          lineColor={0,0,0},
          textString="%name"), Line(
          points={{-20,20},{-44,42},{-66,32},{-80,0}},
          color={0,0,0},
          smooth=Smooth.Bezier), Line(
          points={{20,-20},{44,-42},{66,-32},{80,0}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
   <p>
      This model is meant as a simple framework to create a photovoltaic power plant that consists of:
   </p>
   <ul>
      <li>Generator/Converter</li>
      <li>Electrical Controller</li>
      <li>Plant Controller</li>
   </ul>
   <p>
      The type of each can be selected via a drop down list where also
      a deactivation is provided (normally via feed through).
   </p>
   <p>
      The type of control configuration can also be selected via drop down list.
   </p>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-80},{120,80}})));
end PV_with_inputs_FOR_PAPER2;
