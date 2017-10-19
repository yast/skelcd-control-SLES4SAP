<!--
  Definition of the installation.SLES.xml -> installation.SLES4SAP.xml transformation.
  For now it simply copies all XML tags to the target file.
-->

<xsl:stylesheet version="1.0"
  xmlns:n="http://www.suse.com/1.0/yast2ns"
  xmlns:config="http://www.suse.com/1.0/configns"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.suse.com/1.0/yast2ns"
  exclude-result-prefixes="n"
>

<xsl:output method="xml" indent="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- keep empty <![CDATA[]]>, see https://stackoverflow.com/a/1364900 -->
  <xsl:template match="n:optional_default_patterns">
      <xsl:element name="optional_default_patterns">
          <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
          <xsl:value-of select="text()" disable-output-escaping="yes"/>
          <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
      </xsl:element>
  </xsl:template>

  <xsl:template xml:space="preserve" match="n:system_role[n:id='normal_role']">
        <system_role>
        <id>sles4sap_role</id>

        <!-- the rest is overlaid over the feature sections and values. -->
        <partitioning>
          <try_separate_home config:type="boolean">false</try_separate_home>
	  <proposal_lvm config:type="boolean">true</proposal_lvm>
          <root_max_size>80GB</root_max_size>
        </partitioning>
        <software>
          <default_patterns>base Minimal gnome sap_server</default_patterns>
        </software>
        </system_role>
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

  <xsl:template xml:space="preserve" match="n:normal_role">
      <sles4sap_role>
          <!-- TRANSLATORS: a label for a system role -->
          <label>SLES for SAP Applications</label>
      </sles4sap_role>
      <sles4sap_role_description>
          <label>SUSE Linux Enterprise Server for  SAP Applications</label>
      </sles4sap_role_description>
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
