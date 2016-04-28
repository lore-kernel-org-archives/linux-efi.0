From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC PATCH v2 05/10] i2c: add support for ACPI reconfigure
 notifications
Date: Thu, 28 Apr 2016 17:58:47 +0300
Message-ID: <20160428145847.GC32610@lahna.fi.intel.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
 <1461105548-20618-6-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461105548-20618-6-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 20, 2016 at 01:39:03AM +0300, Octavian Purdila wrote:
> This patch adds supports for I2C device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Looks reasonable to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
