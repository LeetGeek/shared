<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                exclude-result-prefixes="msxsl"
                xmlns:user="urn:my-scripts">

  <msxsl:script implements-prefix="user" language="CSharp" >
    <![CDATA[
     public double abs(double value)
     {       
       return Math.Abs(value) * 100;
     }
     
     public string commaFormattedNumber(double value)
     {       
       return value.ToString("N0");
     }
      ]]>
  </msxsl:script>

  <xsl:template match="/">
       <html>
         
         <head>
           <style>
             body { font-family: Calibri; }
             table, th, td {border: 1px solid black; border-collapse: collapse;}
             th, td {padding: 5px;}
           </style>
         </head>

         <body>
           <p>Dear All,</p>
           <p>
             This is an email to notify you that clearing member 
             <xsl:value-of select="EmailParameters/CPCode"/>
             has an intraday deficit limit currently standing at 
             <xsl:value-of select="format-number(user:abs(EmailParameters/CPPortfolioRiskLimitPercentage),'#')"/>%.
           </p>
           <p>
             <xsl:value-of select="EmailParameters/ClearingHouseName"/> 
             will not issue an intraday margin call until 100% of the limit is breached.
           </p>
           <p>Please note that currently the below accounts combine to create the intraday deficit.</p>

           <table>
             <tr>
               <th>Segregation</th>
               <th>Account</th>
               <th>Currency</th>
               <th style="text-align:right">Amount</th>
             </tr>
             <xsl:for-each select="EmailParameters/AccountLineItems/AccountLineItem">
               <tr>
                 <td>
                   <xsl:value-of select="SegCode"/>
                 </td>
                 <td>
                   <xsl:value-of select="AccountName"/>
                 </td>
                 <td>
                   <xsl:value-of select="CurrencyCode"/>
                 </td>
                 <td style="text-align:right">
                   <xsl:value-of select="user:commaFormattedNumber(user:abs(Amount))"/>
                 </td>
               </tr>
             </xsl:for-each>
           </table>

           <p>Regards,<br/>
             <xsl:for-each select="EmailParameters/Signature/*">
                <br/>
                <xsl:value-of select="."/>
             </xsl:for-each>
           </p>

         </body>
       </html>
    </xsl:template>
</xsl:stylesheet>
