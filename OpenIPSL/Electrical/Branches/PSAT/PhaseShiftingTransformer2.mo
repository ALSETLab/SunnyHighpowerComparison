within OpenIPSL.Electrical.Branches.PSAT;
model PhaseShiftingTransformer2

  model PhaseShifter "Controller for shifting the phase (internal model)"
    parameter SI.PerUnit pref=0.01 "Desired power flow"
      annotation (Dialog(group="Phase controller"));
    parameter Real Kp=0.5 "Proportional gain"
      annotation (Dialog(group="Phase controller"));
    parameter Real Ki=0.1 "Integral gain"
      annotation (Dialog(group="Phase controller"));
    parameter SI.Time Tm=0.001 "Measurement time constant"
      annotation (Dialog(group="Phase controller"));
    parameter SI.Angle alpha_max=C.pi/2 "Maximum phase angle"
      annotation (Dialog(group="Phase controller"));
    parameter SI.Angle alpha_min=-C.pi/2 "Minimum phase angle"
      annotation (Dialog(group="Phase controller"));
    parameter SI.PerUnit pmes0=0.01 "Initial measured power flow"
      annotation (Dialog(group="Initialization"));
    parameter SI.Angle alpha0=0 "Initial phase shifting angle"
      annotation (Dialog(group="Initialization"));

    outer SI.PerUnit pk "Actual secondary power flow";
    SI.PerUnit pmes(start=pmes0) "Measured power flow";
    SI.Angle alpha(start=alpha0) "Shifting angle";

  Interfaces.PwPin          p
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.PwPin n annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  equation
  if alpha > alpha_max and der(alpha) > 0 and der(pmes) > 0 then
    der(alpha) = 0;
    der(pmes) = (pk - pmes)/Tm;
    p.vr = n.vr*cos(alpha_max) - n.vi*sin(alpha_max);
    p.vi = n.vr*sin(alpha_max) + n.vi*cos(alpha_max);

  elseif alpha < alpha_min and der(alpha) < 0 and der(pmes) < 0 then
    der(alpha) = 0;
    der(pmes) = (pk - pmes)/Tm;
    p.vr = n.vr*cos(alpha_min) - n.vi*sin(alpha_min);
    p.vi = n.vr*sin(alpha_min) + n.vi*cos(alpha_min);
  else
    der(alpha) = Kp*(pk - pmes)/Tm + Ki*(pmes - pref);
    der(pmes) = (pk - pmes)/Tm;
    p.vr = n.vr*cos(alpha) - n.vi*sin(alpha);
    p.vi = n.vr*sin(alpha) + n.vi*cos(alpha);
  end if;
  p.ir + n.ir = 0;
  p.ii + n.ii = 0;

  end PhaseShifter;

  parameter SI.ApparentPower S_b(displayUnit="MVA")=SysData.S_b "System base power"
    annotation (Dialog(group="Power flow"));
  parameter SI.Voltage V_b(displayUnit="kV")=40e3 "Sending end bus voltage"
    annotation (Dialog(group="Power flow"));
  parameter SI.ApparentPower Sn(displayUnit="MVA")=SysData.S_b "Power rating"
    annotation (Dialog(group="Transformer parameters"));
  parameter SI.Voltage Vn(displayUnit="kV")=40e3 "Voltage rating"
    annotation (Dialog(group="Transformer parameters"));
  parameter SI.PerUnit rT=0.01 "Resistance (pu, transformer base)"
    annotation (Dialog(group="Transformer parameters"));
  parameter SI.PerUnit xT=0.1 "Reactance (pu, transformer base)"
    annotation (Dialog(group="Transformer parameters"));
  parameter Real m=1.0 "Optional fixed tap ratio"
    annotation (Dialog(group="Transformer parameters"));
  parameter SI.PerUnit pref=0.01 "Desired power flow"
    annotation (Dialog(group="Phase controller"));
  parameter Real Kp=0.5 "Proportional gain"
    annotation (Dialog(group="Phase controller"));
  parameter Real Ki=0.1 "Integral gain"
    annotation (Dialog(group="Phase controller"));
  parameter SI.Time Tm=0.001 "Measurement time constant"
    annotation (Dialog(group="Phase controller"));
  parameter SI.Angle alpha_max=C.pi/2 "Maximum phase angle"
    annotation (Dialog(group="Phase controller"));
  parameter SI.Angle alpha_min=-C.pi/2 "Minimum phase angle"
    annotation (Dialog(group="Phase controller"));
  parameter SI.PerUnit pmes0=0.01 "Initial measured power flow"
    annotation (Dialog(group="Initialization"));
  parameter SI.Angle alpha0=0 "Initial phase shifting angle"
    annotation (Dialog(group="Initialization"));



  outer OpenIPSL.Electrical.SystemBase SysData;
  inner SI.PerUnit pk "Actual primary power flow";
  SI.Angle anglevk "Angle at primary";
  SI.Angle anglevm "Angle at secondary";
  SI.PerUnit vk "Voltage at primary";
  SI.PerUnit vm "Voltage at secondary";

  TwoWindingTransformer twoWindingTransformer(
    S_b=S_b,
    V_b=V_b,
    Sn=Sn,
    Vn=Vn,
    rT=rT,
    xT=xT,
    m=m)                                      annotation (Placement(transformation(extent={{-60,-20},{-20,20}})));
  PhaseShifter phaseShifter(
    pref=pref,
    Kp=Kp,
    Ki=Ki,
    Tm=Tm,
    alpha_max=alpha_max,
    alpha_min=alpha_min,
    pmes0=pmes0,
    alpha0=alpha0)          annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Interfaces.PwPin n annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.PwPin p annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
equation
  vk = sqrt(p.vr^2 + p.vi^2);
  vm = sqrt(n.vr^2 + n.vi^2);
  anglevk = atan2(p.vi, p.vr);
  anglevm = atan2(n.vi, n.vr);
  pk=p.vr*p.ir + p.vi*p.ii;

  connect(twoWindingTransformer.p, p) annotation (Line(points={{-62,0},{-110,0}}, color={0,0,255}));
  connect(twoWindingTransformer.n, phaseShifter.p) annotation (Line(points={{-18,0},{19,0}}, color={0,0,255}));
  connect(phaseShifter.n, n) annotation (Line(points={{41,0},{110,0}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Ellipse(extent={{-50,28},{10,-32}}, lineColor={0,
          0,255}),Ellipse(extent={{-10,30},{50,-30}},lineColor={0,0,255}),Line(
          points={{-100,0},{-50,0}},
          color={0,0,255},
          smooth=Smooth.None),Rectangle(extent={{64,14},{94,-16}}, lineColor={0,
          0,255}),Line(
          points={{50,0},{64,0},{64,0}},
          color={0,0,255},
          smooth=Smooth.None),Line(
          points={{80,-16},{80,-40},{-50,-40},{-50,-4},{-50,-4}},
          color={0,0,255},
          smooth=Smooth.None),Text(
          extent={{70,8},{90,-12}},
          lineColor={0,0,255},
          textStyle={TextStyle.Bold},
          textString="deg"),    Text(
          extent={{-40,-60},{40,-100}},
          lineColor={0,128,0},
          textString="PST"),
        Text(
          extent={{-100,100},{100,40}},
          lineColor={0,0,255},
          textString="%name"),
                  Line(
          points={{94,0},{100,0},{100,0}},
          color={0,0,255},
          smooth=Smooth.None)}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end PhaseShiftingTransformer2;
