From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v5 8/8] acpi: add support for loading SSDTs via configfs
Date: Thu, 7 Jul 2016 12:42:42 +0300
Message-ID: <20160707094242.GQ23527@lahna.fi.intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-9-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-9-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 01, 2016 at 11:19:12PM +0300, Octavian Purdila wrote:
> New tables can be loaded by creating directories under /config/table/
> and writing the AML code into the aml table attribute. Various table
> attributes will be readable once the table is successfully loaded.
> 
> Unloading tables is not supported at the moment, but it can be easily
> implemented once ACPI loading functions provide a table handle to be
> used for unloading.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
