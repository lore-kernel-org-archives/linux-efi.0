From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
Date: Sun, 30 Jul 2017 08:32:24 -0700
Message-ID: <20170730153224.GA31755@kroah.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501063301.29303.247.camel@linux.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 26, 2017 at 01:01:41PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-07-19 at 21:28 +0300, Andy Shevchenko wrote:
> > There are new types and helpers that are supposed to be used in new
> > code.
> > 
> > As a preparation to get rid of legacy types and API functions do
> > the conversion here.
> > 
> > While here, re-indent couple of lines to increase readability.
> 
> This looks like no user space UUID API is involved, can be routed via
> either tree (uuid or staging).
> 
> Anyone to comment?

Doesn't apply to the staging tree at all :(
