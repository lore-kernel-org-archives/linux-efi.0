From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 08/10] configfs: fix CONFIGFS_BIN_ATTR_[RW]O definitions
Date: Thu, 31 Mar 2016 12:37:04 +0300
Message-ID: <1459417026-6697-9-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

The type should be struct configfs_bin_attribute and not struct
configfs_attribute.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 include/linux/configfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index f8165c1..ada0613 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -181,7 +181,7 @@ static struct configfs_bin_attribute _pfx##attr_##_name = {	\
 }
 
 #define CONFIGFS_BIN_ATTR_RO(_pfx, _name, _priv, _maxsz)	\
-static struct configfs_attribute _pfx##attr_##_name = {		\
+static struct configfs_bin_attribute _pfx##attr_##_name = {	\
 	.cb_attr = {						\
 		.ca_name	= __stringify(_name),		\
 		.ca_mode	= S_IRUGO,			\
@@ -193,7 +193,7 @@ static struct configfs_attribute _pfx##attr_##_name = {		\
 }
 
 #define CONFIGFS_BIN_ATTR_WO(_pfx, _name, _priv, _maxsz)	\
-static struct configfs_attribute _pfx##attr_##_name = {		\
+static struct configfs_bin_attribute _pfx##attr_##_name = {	\
 	.cb_attr = {						\
 		.ca_name	= __stringify(_name),		\
 		.ca_mode	= S_IWUSR,			\
-- 
1.9.1
