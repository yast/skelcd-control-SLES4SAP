<!--
  Definition of the installation.SLES.xml -> installation.SLES4SAP.xml transformation.
  For now it simply copies all XML tags to the target file.
-->

<xsl:stylesheet version="1.0"
  xmlns:n="http://www.suse.com/1.0/yast2ns"
  xmlns:config="http://www.suse.com/1.0/configns"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="n:try_separate_home">
	<try_separate_home config:type="boolean">false</try_separate_home>
  </xsl:template>

  <xsl:template match="n:root_base_size">
	<root_base_size>60GB</root_base_size>
  </xsl:template>

  <xsl:template match="n:root_max_size">
	<root_max_size>80GB</root_max_size>
  </xsl:template>

  <xsl:template match="n:proposal_lvm">
	<proposal_lvm config:type="boolean">true</proposal_lvm>
	<lvm_vg_strategy>use_needed</lvm_vg_strategy>
  </xsl:template>

  <xsl:template match="n:module[n:name='user_first']">
         <module>
                   <label>Installation Mode</label>
                   <name>sap-start</name>
                   <enable_back>yes</enable_back>
                   <enable_next>yes</enable_next>
         </module>
  </xsl:template>

</xsl:stylesheet>
