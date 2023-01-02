within OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.BaseClasses;
model PIwithVariableLimiter "PI with variable limiter controller for WECC electrical controllers"
  import Modelica.Units.SI;
  parameter SI.PerUnit K_P "Voltage regulator proportional gain";
  parameter SI.TimeAging K_I "Voltage regulator integral gain";
  parameter Real y_start "Starting output value for the integrator";
  Modelica.Blocks.Continuous.Integrator    integral(
    k=K_I,
    use_reset=false,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=y_start)
    annotation (Placement(transformation(extent={{4,30},{24,50}})));
  Modelica.Blocks.Math.Gain proportional(k=K_P)
    annotation (Placement(transformation(extent={{-26,-50},{-6,-30}})));
  Modelica.Blocks.Math.Add PI_add
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Modelica.Blocks.Logical.Switch reset_switch
    annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-88,70},{-68,90}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput limit1
    "Connector of Real input signal used as maximum of input u" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
  Modelica.Blocks.Interfaces.RealInput limit2
    "Connector of Real input signal used as minimum of input u" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  Modelica.Blocks.Interfaces.BooleanInput voltage_dip
    "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
equation
  or1.u2 =
  if (abs(variableLimiter1.limit1 - y) <= Modelica.Constants.eps and der(integral.y)>0) then true
  else if (abs(variableLimiter1.limit2 - y) <= Modelica.Constants.eps and der(integral.y)<0) then true
  else false;
  connect(proportional.y, PI_add.u2) annotation (Line(points={{-5,-40},{30,-40},
          {30,-6},{36,-6}}, color={0,0,127}));
  connect(reset_switch.u1,realExpression. y)
    annotation (Line(points={{-58,48},{-58,80},{-67,80}},
                                                 color={0,0,127}));
  connect(reset_switch.u3,u)  annotation (Line(points={{-58,32},{-70,32},{-70,
          -60},{-120,-60}},
                     color={0,0,127}));
  connect(reset_switch.y,integral. u)
    annotation (Line(points={{-35,40},{2,40}},   color={0,0,127}));
  connect(proportional.u,u)
    annotation (Line(points={{-28,-40},{-70,-40},{-70,-60},{-120,-60}},
                                                color={0,0,127}));
  connect(PI_add.y, variableLimiter1.u)
    annotation (Line(points={{59,0},{68,0}}, color={0,0,127}));
  connect(variableLimiter1.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(variableLimiter1.limit1, limit1)
    annotation (Line(points={{68,8},{68,120},{60,120}},
                                               color={0,0,127}));
  connect(variableLimiter1.limit2, limit2)
    annotation (Line(points={{68,-8},{68,-120},{60,-120}},
                                                 color={0,0,127}));
  connect(integral.y, PI_add.u1)
    annotation (Line(points={{25,40},{30,40},{30,6},{36,6}}, color={0,0,127}));
  connect(or1.y, reset_switch.u2)
    annotation (Line(points={{-71,40},{-58,40}}, color={255,0,255}));
  connect(or1.u1, voltage_dip)
    annotation (Line(points={{-94,40},{-108,40},{-108,60},{-120,60}},
                                                  color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}), Text(
          extent={{-80,40},{80,-40}},
          textColor={0,0,255},
          textString="PI WECC Renewables")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
Specific PI with variable limiter component for the WECC-based renewable energy controller models. 
</p>
<p>The modelling of such component is based, mainly, on the following reference:</p>
<ul>
<li>Mohammed, M., Federico, M.: \"Modeling and Simulation of PI-Controllers Limiters for the Dynamic Analysis of VSC-Based Devices\" 
<a href=\"modelica://OpenIPSL.UsersGuide.References\">[Mohammed2019]</a>,</li>
</ul>
</html>"));
end PIwithVariableLimiter;
