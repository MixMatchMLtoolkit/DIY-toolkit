<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>

  <xsl:param name="dataselected" select="data/datatoken[ltoken=$tokenselected]/dataname"></xsl:param>

  <xsl:template match="/">
    <html>
      <body >
        <header>

          <div class="headerData">
            <div class='leftheader'>
              <img>

                <xsl:attribute name="class">labelimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="data/labeledimage"/>
                </xsl:attribute>
              </img>
              <img>

                <xsl:attribute name="class">dataimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/image"/>
                </xsl:attribute>
              </img>
              <p class='overlaptext'><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/datatype"/></p>
              <p class='overlaptext2'>Labeled training dataset</p>
            </div>

            <div class='rightheader'>

              <xsl:for-each select="data/datatoken[ltoken=$tokenselected]">
                <h3 class='type labeled'><xsl:value-of select="dataname"/>
                  data</h3>
                  <p class="descriptionData"><xsl:value-of select="highlightLabeled  "/></p>
                <!-- <h4 class='labeled'><xsl:value-of select="structure"/>
                  data</h4> -->
                  <img>

                    <xsl:attribute name="class">illustration
                    </xsl:attribute>

                    <xsl:attribute name="src"><xsl:value-of select="imageL"/>
                    </xsl:attribute>
                  </img>
                  <!-- <p class='source'>Image source: <xsl:value-of select="source"/></p> -->

                  <div  class='pointer' onclick="showhideInfo()">
                    <p>
                  <i class="fa fa-info-circle fa-lg labeled">&#160;
                  </i>
                  <span class='bold labeled' >More information
                  </span>
                </p>
                </div>
                  <p class='description'>
                  <span id="descHidden">
                  <xsl:value-of select="descriptionLabeled"/>
                </span>
                </p>
                <p>
                  <i class="fa fa-file fa-lg labeled">&#160;
                  </i>
                  <span class='bold labeled'>Possible formats:
                  </span>
                  <span><xsl:value-of select="format"/></span>
                </p>

              </xsl:for-each>
            </div>

          </div>

        </header>

        <div class='centerBlock'>


          <p class="bold labeled">Selection of datasets:</p>
          <table>
            <tr style="background-color: #2D7F83;">
              <th >Dataset</th>
              <th>Description</th>
              <th>Labeled</th>
              <!-- <th>Link</th> -->
            </tr>

            <xsl:for-each select="data/records/record[datatype=$dataselected and labeled='yes']">
              <tr>
                <td>
                  <a href="{url/@xlink:href}" target="_blank">

                    <xsl:attribute name="onclick">sendlinkOOCSI("datalink","<xsl:value-of select="dataset"/>")
                    </xsl:attribute>

                    <xsl:value-of select="dataset"/></a>
                </td>
                <!-- <td><xsl:value-of select="dataset"/></td> -->
                <td><xsl:value-of select="description"/></td>
                <td><xsl:value-of select="labeled"/></td>

              </tr>

            </xsl:for-each>
          </table>
        </div>

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
