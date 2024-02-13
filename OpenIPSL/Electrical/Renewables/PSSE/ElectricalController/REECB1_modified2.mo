within OpenIPSL.Electrical.Renewables.PSSE.ElectricalController;
model REECB1_modified2
  "Electrical control model for large scale photovoltaic"
  extends
    OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.BaseClasses.BaseREECB(
     Iqcmd, Ipcmd);

  parameter OpenIPSL.Types.PerUnit Vdip = -99 "Low voltage threshold to activate reactive current injection logic (0.85 - 0.9)";
  parameter OpenIPSL.Types.PerUnit Vup = 99 "Voltage above which reactive current injection logic is activated (>1.1)";
  parameter OpenIPSL.Types.Time Trv = 0 "Filter time constant for voltage measurement (0.01 - 0.02)";
  parameter OpenIPSL.Types.PerUnit dbd1 = -0.05 "Voltage error dead band lower threshold (-0.1 - 0)";
  parameter OpenIPSL.Types.PerUnit dbd2 = 0.05 "Voltage error dead band upper threshold (0 - 0.1)";
  parameter Real Kqv = 0 "Reactive current injection gain during over and undervoltage conditions (0 - 10)";
  parameter OpenIPSL.Types.PerUnit Iqh1 = 1.05 "Upper limit on reactive current injection Iqinj (1 - 1.1)";
  parameter OpenIPSL.Types.PerUnit Iql1 = -1.05 "Lower limit on reactive current injection Iqinj (-1.1 - 1)";
  parameter OpenIPSL.Types.PerUnit vref0 = 1 "User defined voltage reference (0.95 - 1.05)";
  parameter OpenIPSL.Types.Time Tp = 0.05 "Filter time constant for electrical power (0.01 - 0.1)";
  parameter OpenIPSL.Types.PerUnit Qmax = 0.4360 "Upper limits of the limit for reactive power regulator (0.4 - 1.0)";
  parameter OpenIPSL.Types.PerUnit Qmin = -0.4360 "Lower limits of the limit for reactive power regulator (-1.0 - -0.4)";
  parameter OpenIPSL.Types.PerUnit Vmax = 1.1 "Maximum limit for voltage control (1.05 - 1.1)";
  parameter OpenIPSL.Types.PerUnit Vmin = 0.9 "Lower limits of input signals (0.9 - 0.95)";
  parameter Real Kqp = 0 "Reactive power regulator proportional gain (No predefined range)";
  parameter Real Kqi = 0.1 "Reactive power regulator integral gain (No predefined range)";
  parameter Real Kvp = 0 "Voltage regulator proportional gain (No predefined range)";
  parameter Real Kvi = 40 "Voltage regulator integral gain (No predefined range)";
  parameter Real Kqvp = 0 "Voltage regulator proportional gain (No predefined range)";
  parameter Real Kqvi = 40 "Voltage regulator integral gain (No predefined range)";
  parameter OpenIPSL.Types.Time Tiq = 0.02 "Time constant on lag delay (0.01 - 0.02)";
  parameter Real dPmax = 99 "Power reference maximum ramp rate (No predefined range)";
  parameter Real dPmin = -99 "Lower limits of input signals (No predefined range)";
  parameter OpenIPSL.Types.PerUnit Pmax = 1 "Maximum power limit";
  parameter OpenIPSL.Types.PerUnit Pmin = 0 "Minimum power limit";
  parameter OpenIPSL.Types.PerUnit Imax = 1.82 "Maximum limit on total converter current (1.1 - 1.3)";
  parameter OpenIPSL.Types.Time Tpord = 0.02 "Power filter time constant (0.01 - 0.02) ";

  Integer Voltage_dip;

  Modelica.Blocks.Sources.BooleanConstant PfFlag_logic(k=pfflag)
    annotation (Placement(transformation(extent={{-236,20},{-216,40}})));
  Modelica.Blocks.Logical.Switch PfFlag
    "Constant Q (False) or PF (True) local control."
    annotation (Placement(transformation(extent={{-196,56},{-176,76}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=Qmax, uMin=Qmin)
    annotation (Placement(transformation(extent={{-162,56},{-142,76}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-132,50},{-112,70}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=Kqi,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=V0)
    annotation (Placement(transformation(extent={{-94,10},{-74,30}})));
  Modelica.Blocks.Math.Gain gain(k=Kqp)
    annotation (Placement(transformation(extent={{-92,50},{-72,70}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-66,44},{-46,64}})));
  Modelica.Blocks.Sources.RealExpression frzState(y=if Voltage_dip == 1 then 0
         else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-112,2})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{-122,10},{-102,30}})));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax=Vmax, uMin=Vmin)
    annotation (Placement(transformation(extent={{-38,44},{-18,64}})));
  Modelica.Blocks.Sources.BooleanConstant Vflag_logic(k=vflag)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Logical.Switch VFlag
    "Constant Q (False) or PF (True) local control."
    annotation (Placement(transformation(extent={{-2,44},{18,64}})));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax=Vmax, uMin=Vmin)
    annotation (Placement(transformation(extent={{28,44},{48,64}})));
  Modelica.Blocks.Math.Add add4(k2=-1)
    annotation (Placement(transformation(extent={{60,44},{80,64}})));
  Modelica.Blocks.Sources.RealExpression Vt_filt2(y=simpleLag.y)
    annotation (Placement(transformation(extent={{80,44},{60,24}})));
  Modelica.Blocks.Math.Gain gain1(k=Kvp)
    annotation (Placement(transformation(extent={{100,44},{120,64}})));
  Modelica.Blocks.Continuous.Integrator integrator1(
    k=Kvi,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=-Iq0 - (-V0 + Vref0)*Kqv)
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Math.Add add5
    annotation (Placement(transformation(extent={{128,38},{148,58}})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  Modelica.Blocks.Sources.RealExpression frzState1(y=if Voltage_dip == 1 then 0
         else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={30,-6})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2
    annotation (Placement(transformation(extent={{162,38},{182,58}})));
  Modelica.Blocks.Sources.RealExpression IQMAX_(y=ccl.Iqmax) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={172,74})));
  Modelica.Blocks.Sources.RealExpression IQMIN_(y=ccl.Iqmin) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={172,24})));
  Modelica.Blocks.Logical.Switch QFlag
    annotation (Placement(transformation(extent={{200,4},{220,24}})));
  Modelica.Blocks.Sources.BooleanConstant QFLAG(k=qflag)
    annotation (Placement(transformation(extent={{160,-14},{180,6}})));
  Modelica.Blocks.Math.Add add6(k2=+1)
    annotation (Placement(transformation(extent={{230,70},{250,90}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter
    annotation (Placement(transformation(extent={{264,70},{284,90}})));
  Modelica.Blocks.Sources.RealExpression IQMIN(y=ccl.Iqmin)
    annotation (Placement(transformation(extent={{284,70},{264,50}})));
  Modelica.Blocks.Sources.RealExpression IQMAX(y=ccl.Iqmax)
    annotation (Placement(transformation(extent={{284,94},{264,114}})));
  Modelica.Blocks.Math.Add add7(k2=-1)
    annotation (Placement(transformation(extent={{54,-86},{74,-66}})));
  Modelica.Blocks.Continuous.Integrator integrator2(k=1/Tiq, y_start=-Iq0 - (-
        V0 + Vref0)*Kqv)
    annotation (Placement(transformation(extent={{134,-80},{154,-60}})));
  Modelica.Blocks.Math.Product product4
    annotation (Placement(transformation(extent={{98,-80},{118,-60}})));
  Modelica.Blocks.Sources.RealExpression Vt_filt1(y=simpleLag.y)
    annotation (Placement(transformation(extent={{-66,-100},{-46,-80}})));
  Modelica.Blocks.Nonlinear.Limiter limiter4(uMax=Modelica.Constants.inf, uMin=0.01)
    annotation (Placement(transformation(extent={{-26,-100},{-6,-80}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{14,-80},{34,-60}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1
    annotation (Placement(transformation(extent={{54,-180},{74,-160}})));
  Modelica.Blocks.Sources.RealExpression IPMAX(y=ccl.Ipmax) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={64,-140})));
  Modelica.Blocks.Sources.RealExpression IPMIN(y=ccl.Ipmin)
    annotation (Placement(transformation(extent={{74,-210},{54,-190}})));
  NonElectrical.Continuous.SimpleLag simpleLag(
    K=1,
    T=Trv,
    y_start=V0)
    annotation (Placement(transformation(extent={{-286,150},{-266,170}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-246,144},{-226,164}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=Iqh1, uMin=Iql1)
    annotation (Placement(transformation(extent={{88,146},{108,166}})));
  Modelica.Blocks.Nonlinear.DeadZone dbd1_dbd2(uMax=dbd2, uMin=dbd1)
    annotation (Placement(transformation(extent={{-206,144},{-186,164}})));
  NonElectrical.Continuous.SimpleLag simpleLag1(
    K=1,
    T=Tp,
    y_start=p00)
    annotation (Placement(transformation(extent={{-266,70},{-246,90}})));
  Modelica.Blocks.Math.Tan tan1
    annotation (Placement(transformation(extent={{-266,60},{-246,40}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-236,64},{-216,84}})));
  Modelica.Blocks.Sources.RealExpression PFAREF(y=pfangle)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-286,50})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-72,-180},{-52,-160}})));
  Modelica.Blocks.Nonlinear.Limiter limiter5(uMax=Modelica.Constants.inf, uMin=0.01)
    annotation (Placement(transformation(extent={{-132,-220},{-112,-200}})));
  Modelica.Blocks.Math.Add add8(k2=-1)
    annotation (Placement(transformation(extent={{-276,-176},{-256,-156}})));
  Modelica.Blocks.Nonlinear.Limiter limiter7(uMax=dPmax, uMin=dPmin)
    annotation (Placement(transformation(extent={{-240,-176},{-220,-156}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k=1/Tpord, y_start=Ip0*V0)
    annotation (Placement(transformation(extent={{-152,-176},{-132,-156}})));
  Modelica.Blocks.Nonlinear.Limiter limiter8(uMax=Pmax, uMin=Pmin)
    annotation (Placement(transformation(extent={{-112,-176},{-92,-156}})));
  Modelica.Blocks.Sources.RealExpression Vt_filt3(y=simpleLag.y)
    annotation (Placement(transformation(extent={{-198,-220},{-178,-200}})));
  OpenIPSL.Electrical.Renewables.PSSE.ElectricalController.BaseClasses.CurrentLimitLogicREECB
    ccl(
    start_ii=-Iq0,
    start_ir=Ip0,
    Imax=Imax)
    annotation (Placement(transformation(extent={{260,-40},{280,-20}})));
  Modelica.Blocks.Sources.BooleanConstant Pqflag_logic(k=pqflag)
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));

  Modelica.Blocks.Sources.RealExpression frzState2(y=if Voltage_dip == 1 then 0
         else 1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={-230,-130})));
  Modelica.Blocks.Math.Product product6
    annotation (Placement(transformation(extent={{-190,-176},{-170,-156}})));
  Modelica.Blocks.Nonlinear.Limiter limiter6(uMax=dPmax, uMin=dPmin)
    annotation (Placement(transformation(extent={{-84,138},{-64,158}})));
  Modelica.Blocks.Continuous.Integrator integrator4(k=1/Tpord, y_start=0)
    annotation (Placement(transformation(extent={{-36,138},{-16,158}})));
  Modelica.Blocks.Math.Gain gain3(k=Kqvp)
    annotation (Placement(transformation(extent={{-90,188},{-70,208}})));
  Modelica.Blocks.Math.Add add3
    annotation (Placement(transformation(extent={{40,146},{60,166}})));
  Modelica.Blocks.Sources.CombiTimeTable VM(table=[0.051008,346.8431742;
        0.160017,346.8316272; 0.221316,346.8316272; 0.359043,346.8316272;
        0.418834,346.8431742; 0.539918,346.8431742; 0.600896,346.8547212;
        0.719814,346.8547212; 0.781788,346.8489477; 0.922828,346.8489477;
        0.985734,346.8720417; 1.04775,346.8720417; 1.157777,346.8316272;
        1.232795,346.8316272; 1.354504,346.8316272; 1.417078,346.8489477;
        1.542821,346.8489477; 1.6035,346.8489477; 1.650502,346.8489477;
        1.774767,346.8547212; 1.853783,346.8547212; 1.993659,346.8316272;
        2.04068,346.8316272; 2.150319,346.8316272; 2.228117,346.8489477;
        2.368409,346.8489477; 2.429924,346.8431742; 2.549349,346.8431742;
        2.609093,346.8662682; 2.729842,346.8662682; 2.791354,346.8316272;
        2.930402,346.8316272; 3.007943,346.8662682; 3.147145,346.8662682;
        3.223258,346.8431742; 3.377255,346.8431742; 3.454534,346.8316272;
        3.579985,346.8604947; 3.641037,346.8604947; 3.766156,346.8604947;
        3.828306,346.8258537; 3.970032,346.8258537; 4.034064,346.8604947;
        4.143849,346.8604947; 4.190829,346.8431742; 4.25257,346.8431742;
        4.392754,346.8316272; 4.45364,346.8316272; 4.559358,346.8604947;
        4.619726,346.8604947; 4.769012,346.8604947; 4.829928,346.8258537;
        4.984643,346.8258537; 5.04718,346.8431742; 5.155157,346.8547212;
        5.21616,346.8547212; 5.355176,346.8547212; 5.434249,346.8316272;
        5.556981,346.8316272; 5.620221,346.8489477; 5.747175,346.8489477;
        5.808887,346.8316272; 5.967548,346.8316272; 6.029192,346.8489477;
        6.138252,346.8489477; 6.202332,346.8431742; 6.326356,346.8431742;
        6.404462,346.8431742; 6.523486,346.8431742; 6.58351,346.8547212;
        6.643907,346.8547212; 6.763209,346.8547212; 6.808509,346.8316272;
        6.965201,346.8316272; 7.027088,346.8489477; 7.15025,346.8489477;
        7.211703,346.8374007; 7.335233,346.8374007; 7.411796,346.8431742;
        7.53633,346.8431742; 7.598231,346.8547212; 7.722573,346.8547212;
        7.784816,346.8316272; 7.956225,346.8316272; 8.019299,346.8604947;
        8.173782,346.8604947; 8.314604,346.8374007; 8.392246,346.8431742;
        8.544563,346.8431742; 8.619574,346.8431742; 8.754155,346.8431742;
        8.814878,346.8489477; 8.956247,346.8489477; 9.035199,346.8489477;
        9.144369,346.8489477; 9.206252,346.8662682; 9.363344,346.8662682;
        9.42519,346.8258537; 9.56626,346.8258537; 9.628247,346.8547212;
        9.765261,346.8547212; 9.826872,346.8374007; 9.983987,346.8374007;
        10.04627,346.8489477; 10.153962,346.8489477; 10.231889,346.8662682;
        10.387867,346.8662682; 10.450476,346.8374007; 10.58376,346.8431742;
        10.645139,346.8431742; 10.766584,346.8431742; 10.829381,346.8489477;
        10.984609,346.8489477; 11.047317,346.8489477; 11.185627,346.8489477;
        11.338134,346.8489477; 11.399812,346.8604947; 11.522397,346.8604947;
        11.598156,346.8374007; 11.724322,346.8374007; 11.787127,346.8431742;
        11.945008,346.8431742; 12.02321,346.8489477; 12.149119,346.8489477;
        12.211072,346.8431742; 12.365319,346.8431742; 12.426957,346.8374007;
        12.578355,346.8374007; 12.654107,346.8547212; 12.789933,346.8431742;
        12.928669,346.8431742; 13.006173,346.8662682; 13.130343,346.8662682;
        13.222757,346.8316272; 13.360046,346.8316272; 13.419734,346.8604947;
        13.573625,346.8604947; 13.634687,346.8316272; 13.77355,346.8316272;
        13.851562,346.8604947; 13.991989,346.8316272; 14.133466,346.8316272;
        14.195361,345.0764824; 14.336847,345.0764824; 14.400806,343.9217819;
        14.538283,343.9217819; 14.598078,343.9506494; 14.718124,343.9506494;
        14.793304,343.9275554; 14.853224,343.9275554; 14.990493,343.9448759;
        15.053472,343.9448759; 15.164641,343.9275554; 15.256586,343.9275554;
        15.381984,343.9448759; 15.443998,343.9448759; 15.568149,343.9448759;
        15.644293,343.9391024; 15.784231,343.9391024; 15.941672,343.9564229;
        16.020716,343.9448759; 16.146407,343.9448759; 16.224023,343.9506494;
        16.366411,343.9506494; 16.428678,343.9333289; 16.566417,343.9333289;
        16.626445,343.9448759; 16.777425,343.9448759; 16.852435,343.9448759;
        17.00943,343.9333289; 17.135337,343.9333289; 17.199034,343.9679699;
        17.323553,343.9679699; 17.400437,343.9679699; 17.523015,343.9679699;
        17.585655,343.9737434; 17.645439,343.9737434; 17.769487,343.9737434;
        17.84546,340.2902487; 17.986564,339.2567917; 18.049566,339.2567917;
        18.207313,339.3549412; 18.334689,339.3549412; 18.413253,339.4299968;
        18.538325,339.4299968; 18.598595,339.5108258; 18.718634,339.5108258;
        18.793673,339.5685608; 18.959312,339.5685608; 19.020718,339.6262959;
        19.144469,339.6262959; 19.221821,339.7013514; 19.377516,339.7013514;
        19.453799,339.7475394; 19.563725,339.7995009; 19.625483,339.7995009;
        19.747932,339.7995009; 19.795727,339.8514625; 19.967875,339.8514625;
        20.030523,339.8861035; 20.14047,339.8861035; 20.216524,339.938065;
        20.357533,339.938065; 20.4206,339.9669325; 20.545506,339.9669325;
        20.608535,339.9900265; 20.745234,339.9900265; 20.806512,340.030441;
        20.956542,340.030441; 21.018727,340.041988; 21.143569,340.041988;
        21.221353,340.0824026; 21.378558,340.0824026; 21.455525,340.1170436;
        21.5627,340.1228171; 21.622968,340.1228171; 21.747536,340.1228171;
        21.794587,340.1516846; 21.967776,340.1516846; 22.0148,339.3838087;
        22.138062,339.3838087; 22.215552,335.4231859; 22.35655,335.4231859;
        22.418287,335.5155619; 22.542582,335.5155619; 22.589519,335.6021645;
        22.650533,335.6021645; 22.76965,335.688767; 22.84462,335.688767;
        22.995112,335.7638225; 23.120719,335.7638225; 23.199885,335.8446516;
        23.324004,335.8446516; 23.40125,335.9023866; 23.524642,335.9023866;
        23.585674,335.9139336; 23.646604,335.9139336; 23.771745,335.9023866;
        23.833645,335.9023866; 23.974729,335.9254806; 24.036795,335.9254806;
        24.161793,335.9254806; 24.222859,335.9139336; 24.364656,335.9139336;
        24.44268,335.9139336; 24.553661,335.9139336; 24.617599,335.9081601;
        24.738431,335.9081601; 24.798857,335.9139336; 24.963679,335.9139336;
        25.03961,335.9139336; 25.165607,335.9139336; 25.22763,335.9081601;
        25.352901,335.9081601; 25.414907,335.9023866; 25.536638,335.9023866;
        25.596645,335.9197071; 25.72163,335.9197071; 25.781898,335.9139336;
        25.923745,335.9139336; 25.985634,335.8966131; 26.046656,335.8966131;
        26.156653,335.8966131; 26.219645,335.9023866; 26.329647,335.9023866;
        26.392464,335.2557543; 26.454706,335.2557543; 26.563774,331.0815119;
        26.626643,331.0815119; 26.746646,331.0815119; 26.806684,331.0815119;
        26.973292,331.0815119; 27.019276,331.0815119; 27.127659,331.0815119;
        27.174641,331.0872854; 27.220837,331.0872854; 27.360662,331.0872854;
        27.438689,331.0815119; 27.545042,331.0815119; 27.60669,331.0872854;
        27.743959,331.0872854; 27.789936,331.0930589; 27.943883,331.0930589;
        28.006701,331.0872854; 28.14846,331.0872854; 28.20968,331.0872854;
        28.334724,331.0872854; 28.396682,331.0872854; 28.520335,331.0872854;
        28.58263,331.0815119; 28.644705,331.0815119; 28.779716,331.0815119;
        28.825691,331.0930589; 28.9897,331.0930589; 29.05012,331.0872854;
        29.157702,331.0872854; 29.234385,331.0872854; 29.35973,331.0872854;
        29.422018,331.0930589; 29.592688,331.0930589; 29.654275,331.0872854;
        29.794187,331.0930589; 29.855726,331.0930589; 30.010745,331.0872854;
        30.138713,331.0872854; 30.185026,331.0872854; 30.325061,331.0872854;
        30.403758,331.0872854; 30.451592,331.0872854; 30.575713,331.0872854;
        30.63868,331.0872854; 30.774557,331.0872854; 30.84945,331.0872854;
        30.983748,331.0872854; 31.045142,331.0872854; 31.154716,331.0872854;
        31.201666,353.7078689; 31.340604,353.7078689; 31.401774,355.1512446;
        31.539801,355.1512446; 31.60187,355.1454711; 31.724825,355.1454711;
        31.786759,355.1396976; 31.941794,355.1396976; 32.019694,355.1512446;
        32.128794,355.1512446; 32.175081,355.1339241; 32.237772,355.1339241;
        32.364936,355.1339241; 32.426773,355.0588685; 32.565924,355.0588685;
        32.642759,354.8279284; 32.779809,354.8279284; 32.824821,354.6316293;
        32.959816,354.6316293; 33.035032,354.4526508; 33.158792,354.4526508;
        33.252795,354.2678987; 33.379819,354.0946936; 33.425778,354.0946936;
        33.565813,354.0946936; 33.626802,353.961903; 33.766746,353.961903;
        33.827762,353.800245; 33.984308,353.800245; 34.123673,353.6905484;
        34.170729,353.6905484; 34.249738,353.6905484; 34.374787,353.6732279;
        34.422784,353.6732279; 34.560879,353.6732279; 34.623388,353.6674544;
        34.730309,353.6674544; 34.790687,353.6443604; 34.939965,353.6443604;
        35.029214,353.6501339; 35.151755,353.6501339; 35.228641,353.6443604;
        35.353461,353.6443604; 35.415386,353.6328134; 35.554398,353.6328134;
        35.600071,353.6270399; 35.722701,353.6270399; 35.799474,353.6154929;
        35.939855,353.6154929; 36.01652,353.6212664; 36.142729,353.6212664;
        36.204187,353.6270399; 36.329706,353.6270399; 36.39277,353.6328134;
        36.519007,353.6328134; 36.582325,353.6097194; 36.643884,353.6097194;
        36.768919,353.6097194; 36.828519,353.6270399; 36.963801,353.6270399;
        37.023749,353.6270399; 37.143412,353.6270399; 37.189141,353.6385869;
        37.327901,353.6385869; 37.390204,353.6443604; 37.529266,353.6443604;
        37.591183,353.6385869; 37.726915,353.6385869; 37.790193,353.6501339;
        37.849686,353.6501339; 37.988928,353.6501339; 38.050641,353.6501339;
        38.176467,353.6385869; 38.237906,353.6385869; 38.362274,353.6385869;
        38.425823,353.6039459; 38.550923,353.6039459; 38.613179,353.5923989;
        38.721494,353.5923989; 38.782926,353.5346638; 38.857925,353.5346638;
        38.992642,353.4884758; 39.05281,353.4884758; 39.157927,353.4711553;
        39.233934,353.4711553; 39.357963,353.4711553; 39.420992,353.4307408;
        39.544161,353.4307408; 39.60496,353.4076468; 39.649945,353.4076468;
        39.771526,353.3903263; 39.833757,353.3903263; 39.973631,353.3903263;
        40.035687,353.3730058; 40.143642,353.3730058; 40.189996,353.3556853;
        40.250733,353.3556853; 40.390056,353.3441382; 40.530124,353.3441382;
        40.592487,353.3094972; 40.65447,353.3094972; 40.763368,353.3094972;
        40.809965,353.3094972; 40.9159,353.3094972; 40.990649,353.2979502;
        41.050237,353.2979502; 41.158,353.2806297; 41.219006,353.2806297;
        41.327985,353.2806297; 41.405074,354.2563517; 41.45114,354.2563517;
        41.575222,358.084184; 41.634616,358.084184; 41.75999,358.084184;
        41.820589,358.0206754; 41.976027,358.0206754; 42.038265,357.9629404;
        42.146875,357.9629404; 42.224702,357.8705644; 42.332258,357.8705644;
        42.410746,357.8532438; 42.533721,357.8532438; 42.580014,357.7781883;
        42.642686,357.7781883; 42.767007,357.7781883; 42.82801,357.7146798;
        42.963888,357.7146798; 43.023874,357.6858123; 43.159039,357.6858123;
        43.218871,357.6511713; 43.327042,357.6511713; 43.390181,357.6049832;
        43.543666,357.6049832; 43.590928,357.5761157; 43.652619,357.5761157;
        43.760248,357.5299277; 43.820571,357.5299277; 43.957072,357.5299277;
        44.019037,357.4895132; 44.127766,357.4895132; 44.190073,357.4895132;
        44.252484,357.4895132; 44.360019,357.4490987; 44.407045,357.4490987;
        44.545723,357.4490987; 44.608049,357.4260046; 44.717078,357.4260046;
        44.779015,357.3971371; 44.825866,357.3971371; 44.962073,357.3971371;
        45.022088,357.3567226; 45.142118,357.3567226; 45.217136,357.3682696;
        45.340068,357.3682696; 45.402862,357.3220816; 45.540908,357.3220816;
        45.602536,357.3220816; 45.726161,357.3220816; 45.787075,357.2932141;
        45.92412,357.2932141; 46.000529,357.2989876; 46.124719,357.2989876;
        46.202667,357.2874406; 46.326935,357.2874406; 46.388073,357.2470261;
        46.450442,357.2470261; 46.57446,357.2585731; 46.651484,357.2585731;
        46.774497,359.175376; 46.836105,359.175376; 46.974416,359.175376;
        47.034112,362.0448068; 47.13957,362.0448068; 47.215117,362.0101658;
        47.337108,362.0101658; 47.400141,362.0332598; 47.539761,362.0332598;
        47.601836,361.9928453; 47.727409,361.9928453; 47.787964,362.0159393;
        47.834718,362.0159393; 47.957652,362.0159393; 48.017821,362.0101658;
        48.171134,362.0101658; 48.264946,362.0159393; 48.358501,362.0159393;
        48.404855,362.0159393; 48.514873,362.0159393; 48.623156,362.0332598;
        48.763699,362.0332598; 48.825992,362.0101658; 48.966145,362.0101658;
        49.117178,361.9986188; 49.177115,362.0217128; 49.327173,362.0217128;
        49.387158,362.0159393; 49.450233,362.0159393; 49.621167,362.0159393;
        49.761429,362.0159393; 49.822247,362.0159393; 49.944189,362.0159393;
        50.051012,362.0159393; 50.15788,362.0101658; 50.235043,362.0101658;
        50.344088,362.0101658; 50.39207,362.0274863; 50.439181,362.0274863;
        50.612709,362.0274863; 50.750804,362.0159393; 50.812423,361.9928453;
        50.920895,361.9928453; 51.029145,362.0332598; 51.13413,362.0332598;
        51.194116,362.0101658; 51.329201,362.0101658; 51.374032,362.0159393;
        51.435018,362.0159393; 51.607207,362.0159393; 51.748108,362.0159393;
        51.824861,361.9928453; 51.947212,361.9928453; 52.054737,362.0217128;
        52.164209,362.0159393; 52.241371,362.0159393; 52.351225,362.0159393;
        52.41428,362.0101658; 52.570116,362.0101658; 52.632647,362.0217128;
        52.755842,362.0217128; 52.818235,362.0043923; 52.943106,362.0043923;
        53.037237,362.0217128; 53.157691,362.0217128; 53.232558,362.0274863;
        53.338264,362.0274863; 53.383281,361.9870718; 53.444268,361.9870718;
        53.615338,361.9870718; 53.755158,362.0101658; 53.818159,362.0159393;
        53.942461,362.0159393; 54.033723,362.0159393; 54.141286,362.0159393;
        54.202008,362.0159393; 54.341935,362.0159393; 54.403954,362.0101658;
        54.450894,362.0101658; 54.607145,362.0159393; 54.730771,362.0159393;
        54.792753,362.0101658; 54.839734,362.0101658; 54.964798,362.0101658;
        55.057974,362.0217128; 55.164376,362.0332598; 55.239288,362.0332598;
        55.359256,362.0332598; 55.419294,362.0217128; 55.541521,362.0217128;
        55.635303,362.0159393; 55.759265,362.0159393; 55.805692,362.0159393;
        55.931331,362.0159393; 56.00863,362.0101658; 56.149348,362.0101658;
        56.210545,362.0159393; 56.334292,362.0159393; 56.381629,352.0335531;
        56.444828,352.0335531; 56.585074,352.0335531; 56.648321,345.4690806;
        56.790654,345.4517601; 56.853326,345.4517601; 56.978329,345.4633071;
        57.040328,345.4633071; 57.164674,345.4633071; 57.258335,345.4690806;
        57.367159,345.4806276; 57.430369,345.4806276; 57.585399,345.4806276;
        57.647364,345.4921746; 57.783364,345.6134181; 57.84338,345.6134181;
        57.94837,345.6134181; 58.02398,345.7577557; 58.192804,345.7577557;
        58.254212,345.8905463; 58.395437,346.0348838; 58.518385,346.0348838;
        58.579366,346.1330334; 58.640367,346.1330334; 58.765411,346.1330334;
        58.844315,346.2254094; 58.984456,346.2254094; 59.030421,346.3524265;
        59.155437,346.3524265; 59.232136,346.450576; 59.342494,346.450576;
        59.389619,346.5371786; 59.453547,346.5371786; 59.564395,346.6468751;
        59.642399,346.6468751; 59.777391,346.6468751; 59.837567,346.7219307;
        59.957519,346.7219307; 60.017408,346.8316272; 60.155738,346.8316272;
        60.232846,346.8489477; 60.341927,346.8489477; 60.418954,346.8604947;
        60.527407,346.8604947; 60.589535,346.8835887; 60.744166,346.8835887;
        60.791146,346.8489477; 60.852135,346.8489477; 60.95975,346.8720417;
        61.020391,346.8720417; 61.159675,346.8720417; 61.205654,346.8489477;
        61.330175,346.8489477; 61.392601,346.8489477; 61.4399,346.8489477;
        61.563368,346.8489477; 61.626384,346.8489477; 61.777117,346.8489477;
        61.852096,346.8604947; 61.956706,346.8316272; 62.017052,346.8316272;
        62.158641,346.8316272; 62.205664,346.8431742; 62.326687,346.8431742;
        62.388702,346.8374007; 62.525736,346.8374007; 62.584751,346.8489477;
        62.73679,346.8489477; 62.798509,346.8200802; 62.921541,346.8200802;
        63.000559,346.8489477; 63.139899,346.8489477; 63.217144,346.8489477;
        63.341189,346.8489477; 63.404193,346.8316272; 63.529481,346.8316272;
        63.59142,346.8374007; 63.741119,346.8374007; 63.801674,346.8489477;
        63.922297,346.8489477; 63.98158,346.8489477; 64.041633,346.8489477;
        64.183494,346.8489477; 64.245312,346.8431742; 64.354542,346.8431742;
        64.417538,346.8489477; 64.542611,346.8489477; 64.587937,346.8374007;
        64.742526,346.8374007; 64.803376,346.8547212; 64.850387,346.8547212])
    annotation (Placement(transformation(extent={{-216,114},{-232,130}})));
  Modelica.Blocks.Math.Gain gain2(k=1/352.01)
    annotation (Placement(transformation(extent={{-242,114},{-258,130}})));
protected
  parameter Real pfaref = p00/sqrt(p00^2 +q00^2) "Power Factor of choice.";
  parameter OpenIPSL.Types.Angle pfangle = if q00 > 0 then acos(pfaref) else -acos(pfaref);
  parameter OpenIPSL.Types.PerUnit Ip0(fixed=false);
  parameter OpenIPSL.Types.PerUnit Iq0(fixed=false);
  parameter OpenIPSL.Types.PerUnit V0(fixed=false);
  parameter OpenIPSL.Types.PerUnit p00(fixed=false);
  parameter OpenIPSL.Types.PerUnit q00(fixed=false);
  parameter OpenIPSL.Types.PerUnit Vref0 = if vref0 == 0 then V0 else vref0;

initial equation

  Ip0 = ip0;
  Iq0 = iq0;
  V0 = v0;
  p00 = p0;
  q00 = q0;

equation

  Voltage_dip = if Vt<Vdip or Vt>Vup then 1 else 0;
  connect(simpleLag.y,add. u1) annotation (Line(points={{-265,160},{-248,160}},
                            color={0,0,127}));
  connect(add.y,dbd1_dbd2. u)
    annotation (Line(points={{-225,154},{-208,154}}, color={0,0,127}));
  connect(simpleLag1.y,product1. u1)
    annotation (Line(points={{-245,80},{-238,80}}, color={0,0,127}));
  connect(tan1.y,product1. u2) annotation (Line(points={{-245,50},{-238,50},{-238,
          68}}, color={0,0,127}));
  connect(Pe,simpleLag1. u)
    annotation (Line(points={{-320,80},{-268,80}}, color={0,0,127}));
  connect(PFAREF.y,tan1. u)
    annotation (Line(points={{-275,50},{-268,50}}, color={0,0,127}));
  connect(Qext,PfFlag. u3) annotation (Line(points={{-320,-80},{-202,-80},{-202,
          58},{-198,58}},
                       color={0,0,127}));
  connect(product1.y,PfFlag. u1)
    annotation (Line(points={{-215,74},{-198,74}}, color={0,0,127}));
  connect(PfFlag_logic.y,PfFlag. u2) annotation (Line(points={{-215,30},{-206,30},
          {-206,66},{-198,66}}, color={255,0,255}));
  connect(PfFlag.y,limiter1. u)
    annotation (Line(points={{-175,66},{-164,66}}, color={0,0,127}));
  connect(limiter1.y,add1. u1)
    annotation (Line(points={{-141,66},{-134,66}}, color={0,0,127}));
  connect(Qgen,add1. u2) annotation (Line(points={{-320,0},{-134,0},{-134,54}},
        color={0,0,127}));
  connect(gain.y,add2. u1)
    annotation (Line(points={{-71,60},{-68,60}}, color={0,0,127}));
  connect(integrator.y,add2. u2)
    annotation (Line(points={{-73,20},{-70,20},{-70,48},{-68,48}},
                                                        color={0,0,127}));
  connect(product2.y,integrator. u)
    annotation (Line(points={{-101,20},{-96,20}},color={0,0,127}));
  connect(frzState.y,product2. u2) annotation (Line(points={{-123,2},{-128,2},{-128,
          14},{-124,14}}, color={0,0,127}));
  connect(add2.y,limiter2. u)
    annotation (Line(points={{-45,54},{-40,54}}, color={0,0,127}));
  connect(limiter2.y,VFlag. u1) annotation (Line(points={{-17,54},{-16,54},{-16,
          62},{-4,62}}, color={0,0,127}));
  connect(Vflag_logic.y,VFlag. u2) annotation (Line(points={{-37,0},{-14,0},{-14,
          54},{-4,54}}, color={255,0,255}));
  connect(limiter3.y,add4. u1) annotation (Line(points={{49,54},{54,54},{54,60},
          {58,60}}, color={0,0,127}));
  connect(Vt_filt2.y,add4. u2) annotation (Line(points={{59,34},{54,34},{54,48},
          {58,48}}, color={0,0,127}));
  connect(VFlag.y,limiter3. u)
    annotation (Line(points={{19,54},{26,54}}, color={0,0,127}));
  connect(gain1.y,add5. u1) annotation (Line(points={{121,54},{126,54}},
                color={0,0,127}));
  connect(integrator1.y,add5. u2) annotation (Line(points={{121,20},{126,20},{126,
          42}}, color={0,0,127}));
  connect(frzState1.y,product3. u2) annotation (Line(points={{41,-6},{52,-6}},
                        color={0,0,127}));
  connect(product3.y,integrator1. u) annotation (Line(points={{75,0},{90,0},{90,
          20},{98,20}}, color={0,0,127}));
  connect(add5.y,variableLimiter2. u)
    annotation (Line(points={{149,48},{160,48}}, color={0,0,127}));
  connect(IQMAX_.y,variableLimiter2. limit1) annotation (Line(points={{161,74},{
          154,74},{154,56},{160,56}}, color={0,0,127}));
  connect(variableLimiter2.y,QFlag. u1)
    annotation (Line(points={{183,48},{198,48},{198,22}}, color={0,0,127}));
  connect(QFLAG.y,QFlag. u2) annotation (Line(points={{181,-4},{186,-4},{186,14},
          {198,14}}, color={255,0,255}));
  connect(IQMIN_.y,variableLimiter2. limit2) annotation (Line(points={{161,24},{
          154,24},{154,40},{160,40}}, color={0,0,127}));
  connect(add6.y,variableLimiter. u)
    annotation (Line(points={{251,80},{262,80}}, color={0,0,127}));
  connect(IQMIN.y,variableLimiter. limit2) annotation (Line(points={{263,60},{256,
          60},{256,72},{262,72}}, color={0,0,127}));
  connect(IQMAX.y,variableLimiter. limit1) annotation (Line(points={{263,104},{256,
          104},{256,88},{262,88}}, color={0,0,127}));
  connect(QFlag.y,add6. u2) annotation (Line(points={{221,14},{228,14},{228,74}},
                     color={0,0,127}));
  connect(add7.y,product4. u2)
    annotation (Line(points={{75,-76},{96,-76}}, color={0,0,127}));
  connect(Vt_filt1.y,limiter4. u)
    annotation (Line(points={{-45,-90},{-28,-90}}, color={0,0,127}));
  connect(limiter4.y,division. u2) annotation (Line(points={{-5,-90},{2,-90},{2,
          -76},{12,-76}},
                     color={0,0,127}));
  connect(division.u1,limiter1. u) annotation (Line(points={{12,-64},{-170,-64},
          {-170,66},{-164,66}},
                            color={0,0,127}));
  connect(division.y,add7. u1)
    annotation (Line(points={{35,-70},{52,-70}}, color={0,0,127}));
  connect(integrator2.y,QFlag. u3) annotation (Line(points={{155,-70},{190,-70},
          {190,6},{198,6}}, color={0,0,127}));
  connect(add7.u2,QFlag. u3) annotation (Line(points={{52,-82},{42,-82},{42,-92},
          {190,-92},{190,6},{198,6}}, color={0,0,127}));
  connect(product4.y,integrator2. u)
    annotation (Line(points={{119,-70},{132,-70}}, color={0,0,127}));
  connect(product4.u1,product3. u2) annotation (Line(points={{96,-64},{84,-64},{
          84,-34},{46,-34},{46,-6},{52,-6}},
                                        color={0,0,127}));
  connect(IPMIN.y,variableLimiter1. limit2) annotation (Line(points={{53,-200},{
          34,-200},{34,-178},{52,-178}}, color={0,0,127}));
  connect(IPMAX.y,variableLimiter1. limit1) annotation (Line(points={{53,-140},{
          34,-140},{34,-162},{52,-162}}, color={0,0,127}));
  connect(variableLimiter1.y, Ipcmd) annotation (Line(points={{75,-170},{254,-170},{254,-170},{310,-170}},
                                color={0,0,127}));
  connect(Vt, simpleLag.u)
    annotation (Line(points={{-320,160},{-288,160}}, color={0,0,127}));
  connect(limiter.y, add6.u1)
    annotation (Line(points={{109,156},{216,156},{216,86},{228,86}},
                                                             color={0,0,127}));
  connect(limiter5.y,division1. u2) annotation (Line(points={{-111,-210},{-86,-210},
          {-86,-176},{-74,-176}}, color={0,0,127}));
  connect(add8.y,limiter7. u)
    annotation (Line(points={{-255,-166},{-242,-166}},
                                                     color={0,0,127}));
  connect(integrator3.y,limiter8. u)
    annotation (Line(points={{-131,-166},{-114,-166}},
                                                     color={0,0,127}));
  connect(add8.u2,limiter8. u) annotation (Line(points={{-278,-172},{-278,-188},
          {-124,-188},{-124,-166},{-114,-166}}, color={0,0,127}));
  connect(limiter8.y,division1. u1) annotation (Line(points={{-91,-166},{-82,-166},
          {-82,-164},{-74,-164}}, color={0,0,127}));
  connect(Vt_filt3.y,limiter5. u)
    annotation (Line(points={{-177,-210},{-134,-210}},
                                                  color={0,0,127}));
  connect(add8.u1, Pref)
    annotation (Line(points={{-278,-160},{-320,-160}}, color={0,0,127}));
  connect(division1.y, variableLimiter1.u)
    annotation (Line(points={{-51,-170},{52,-170}}, color={0,0,127}));
  connect(variableLimiter.y, Iqcmd)
    annotation (Line(points={{285,80},{292,80},{292,170},{310,170}},
                                                 color={0,0,127}));
  connect(Pqflag_logic.y, ccl.Pqflag)
    annotation (Line(points={{241,-30},{258,-30}}, color={255,0,255}));
  connect(ccl.Iqcmd, Iqcmd) annotation (Line(points={{282,-25},{292,-25},{292,170},{310,170}},
                     color={0,0,127}));
  connect(ccl.Ipcmd, Ipcmd) annotation (Line(points={{282,-35},{292,-35},{292,-170},{310,-170}},
                      color={0,0,127}));
  connect(product2.u1, add1.y) annotation (Line(points={{-124,26},{-128,26},{-128,
          40},{-111,40},{-111,60}}, color={0,0,127}));
  connect(gain.u, integrator.u) annotation (Line(points={{-94,60},{-98,60},{-98,
          20},{-96,20}}, color={0,0,127}));
  connect(product3.u1, add4.y) annotation (Line(points={{52,6},{50,6},{50,8},{46,
          8},{46,20},{84,20},{84,54},{81,54}}, color={0,0,127}));
  connect(gain1.u, integrator1.u) annotation (Line(points={{98,54},{90,54},{90,20},
          {98,20}}, color={0,0,127}));
  connect(frzState2.y, product6.u1) annotation (Line(points={{-219,-130},{-204,-130},
          {-204,-160},{-192,-160}}, color={0,0,127}));
  connect(limiter7.y, product6.u2) annotation (Line(points={{-219,-166},{-212,-166},
          {-212,-172},{-192,-172}}, color={0,0,127}));
  connect(product6.y, integrator3.u)
    annotation (Line(points={{-169,-166},{-154,-166}}, color={0,0,127}));
  connect(VFlag.u3, limiter1.u) annotation (Line(points={{-4,46},{-10,46},{-10,
          -64},{-170,-64},{-170,66},{-164,66}}, color={0,0,127}));
  connect(limiter6.y, integrator4.u)
    annotation (Line(points={{-63,148},{-38,148}}, color={0,0,127}));
  connect(gain3.y, add3.u1)
    annotation (Line(points={{-69,198},{38,198},{38,162}}, color={0,0,127}));
  connect(dbd1_dbd2.y, gain3.u) annotation (Line(points={{-185,154},{-104,154},
          {-104,198},{-92,198}}, color={0,0,127}));
  connect(limiter6.u, dbd1_dbd2.y) annotation (Line(points={{-86,148},{-98,148},
          {-98,154},{-185,154}}, color={0,0,127}));
  connect(integrator4.y, add3.u2) annotation (Line(points={{-15,148},{12,148},{
          12,150},{38,150}}, color={0,0,127}));
  connect(add3.y, limiter.u)
    annotation (Line(points={{61,156},{86,156}}, color={0,0,127}));
  connect(gain2.y, add.u2) annotation (Line(points={{-258.8,122},{-268,122},{
          -268,140},{-260,140},{-260,148},{-248,148}}, color={0,0,127}));
  connect(gain2.u, VM.y[1])
    annotation (Line(points={{-240.4,122},{-232.8,122}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
The REECB1 component used to represent the electrical controls of photovoltaic generation. The electrical controller actuates on the active and reactive power
reference from either the plant controller component or from power flow power reference values (in the case where there is no plant controller),
with feedback variables that original from the inverter interface component, specifically terminal voltage and generator power output,
and provides real (Ipcmd) and reactive current (Iqcmd) commands to the REGC types module.
</p>
<p>
For initialization purposes, there are 5 inputs that are derived from the inverter component: initial real and reactive injection currents (IP0 and IQ0), initial terminal voltage (v_0), and initial active and reactive power
injections (p_0 and q_0).
</p>
<p>
In terms of connectivity with other components to form the renewable source, the REECB1 component has five inputs, three of which are connected to the inverter component
(for instance REGCA1), and two more that can either be constant values from the power flow initialization or come from the connection to the plant controller.
The three REECB1 inputs that take in values from the output of the inverter model
are Vt, Pgen, and Qgen while the two inputs that could potentially be constant valued or come from the plant controller are Pref, and Qext.
</p>
<p>The modelling of such devices is based, mainly, on the following references:</p>
<ul>
<li>Siemens: \"PSS&reg;E Model Library\"
<a href=\"modelica://OpenIPSL.UsersGuide.References\">[PSSE-MODELS]</a>,</li>
<li>WECC: \"Solar Photovoltaic Power Plant Modeling and Validation Guideline\"
<a href=\"modelica://OpenIPSL.UsersGuide.References\">[WECCPhotovoltaic]</a>.</li>
</ul>
</html>"));
end REECB1_modified2;
