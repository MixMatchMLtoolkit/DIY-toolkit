<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>

  <xsl:param name="dataselected" select="data/datatoken[token=$tokenselected]/datatype"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>

        <xsl:for-each select="data/datatoken[token=$tokenselected]">
          <header>
            <h2><xsl:value-of select="datatype"/></h2>
            <p class='centerText'><xsl:value-of select="structure"/> data</p>
          </header>
          <div class="centerBlock">
            <p>
              <span class='bold'>Description:
              </span><xsl:value-of select="description"/></p>

            <p>
              <span class='bold'>Possible formats:
              </span>
              <span><xsl:value-of select="format"/></span>
            </p>
            <!-- <p>
              <span class='bold'>Collection methods:
              </span>
              <span>
                <xsl:value-of select="collection"/></span>
            </p> -->

            <p class="bold">Selection of datasets:</p>
          </div>
        </xsl:for-each>
        <div>

          <table>
            <tr >
              <th>Dataset</th>
              <th>Description</th>
              <th>Labeled (1=yes)</th>
              <!-- <th>Link</th> -->
            </tr>

            <xsl:for-each select="data/records/record[datatype=$dataselected]">
              <tr>
                <td>
                  <a href="{url/@xlink:href}" target="_blank"><xsl:value-of select="dataset"/></a>
                </td>
                <!-- <td><xsl:value-of select="dataset"/></td> -->
                <td><xsl:value-of select="description"/></td>
                <td><xsl:value-of select="labeled"/></td>

              </tr>

            </xsl:for-each>
          </table>
        </div>

      </body>
      <footer>
      </footer>
    </html>
  </xsl:template>

</xsl:stylesheet>
