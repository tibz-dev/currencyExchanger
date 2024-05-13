<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="currencyExchanger.WebForm1" Async="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Currency Exchanger</title>
    <style type="text/css">
        @import url(https://fonts.googleapis.com/css2?family=Montserrat:wght@900&amp;display=swap);
        body {
            font-family: "Quicksand";
            background: linear-gradient(to right bottom, #005c97, #363795);
            overflow: hidden;
            overflow-y: hidden;
            overflow-x: hidden;
        }
        .form-container {
            background-color: #fff;
            padding: 20px;
            background: linear-gradient(to right bottom,
            rgba(255, 255, 255, 0.2),
            rgba(255, 255, 255, 0.1));
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 600px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .form-header {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
        }
        .form-input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 3px;
            max-width: 100%;
        }
        .form-submit {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 3px;
        }
        .form-submit:hover {
            background-color: #0056b3;
        }
        .auto-style4 {
            text-align: left;
            height: 473px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .auto-style9 {
            display: block;
            margin-bottom: 5px;
            font-size: x-large;
            text-align: center;
            font-family: "Montserrat", sans-serif;
            text-transform: uppercase;
            color: white;
            background: linear-gradient(-90deg, rgb(223 223 223) 0%, rgba(190, 190, 190, 1) 100%);
            line-height: 1;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            position: relative;
        }
        .auto-style11 {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 3px;
            max-width: 100%;
            margin-top: 20px;
        }
        .auto-style12 {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 3px;
            width: 100%;
            max-width: 100%;
            margin-top: 10px;
        }

         .square {
            height: 100vh;
            width: 50vw;
            display: table;
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            transform: rotate(45deg);
        }

        .square.square-tl {
            top: -80%;
            left: -10%;
            animation: bounce 6s infinite ease-in-out;
            background: rgb(34, 34, 34, 0.1);
            z-index: 50;
        }

        .square.square-tr {
            top: 0%;
            right: -30%;
            animation: bounce 5s infinite ease-in-out;
        }

        .square.square-bl {
            bottom: -70%;
            left: -15%;
            animation: bounce 4s infinite ease-in-out;
        }

        .square.square-br {
            bottom: 0%;
            right: -40%;
            animation: bounce 3s infinite ease-in-out;
            background: rgb(34, 34, 34, 0.1);
        }

        @keyframes bounce {
            0% {transform: translateY(0px) rotate(45deg)}
            50% {
                transform: translateY(20px) rotate(45deg); border-radius: 50px;
            }
            100% {transform: translateY(0px) rotate(45deg)}
        }

        .star {
            height: 50px;
            width: 50px;
            display: table;
            position: absolute;
            box-shadow: 0 0 5px 0 rgba(34, 34, 34, 0.5);
            transition: 0.5s;
        }

        .star1 {
            bottom: -10%;
            left: -30%;
            transform: rotate(-30deg);
            animation: sweep 4s infinite;
            background: rgba(34, 34, 34, 0.5);
        }

        .star2 {
            bottom: -30%;
            left: -10%;
            transform: rotate(-30deg);
            animation: sweep 3s infinite;
            background: rgb(255, 255, 255, 0.5);
        }
        @keyframes sweep {
            100% {bottom: 120%; left: 120%; transform: rotate(360deg);}
        }

        h1:before {
            content: attr(data-text);
            -webkit-background-clip: none;
            -webkit-text-fill-color: black;
            position: absolute;
            z-index: -1;
            filter: blur(14px);
            transform: skew(67deg, 0) translate(-20%, 15%) scaleY(0.5);
            -webkit-mask-image: linear-gradient(180deg, rgba(255, 255, 255, 0) 0%, rgba(0, 0, 0, 1) 100%);
            padding: 0 22px;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server" class="form-container">
        <div class="auto-style4">
            <div class="auto-style9">
                Welcome to Currency Exchanger</div>
            <asp:TextBox ID="txtExchangeRate" runat="server" CssClass="form-input auto-style11" Placeholder="Enter currency code (e.g., USD)"></asp:TextBox>
            <asp:TextBox ID="txtExchangeRate0" runat="server" CssClass="form-input auto-style11" Placeholder="Currency you wish to exchange to (e.g., USD)"></asp:TextBox>

            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="form-submit auto-style12" OnClick="btnSearch_Click" />
            <br />
            <asp:Label ID="lblExchangeRate" runat="server" Text="Label"></asp:Label>
        </div>
    </form>

    <span class="square square-tl"></span>
    <span class="square square-tr"></span>
    <span class="square square-bl"></span>
    <span class="square square-br"></span>
    <span class="star star1"></span>
    <span class="star star2"></span>
</body>
</html>

