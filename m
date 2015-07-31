From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 07/16] efi: Public the function of transferring EFI
 status to kernel error
Date: Fri, 31 Jul 2015 23:11:47 +0800
Message-ID: <20150731151147.GD2067@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-8-git-send-email-jlee@suse.com>
 <1438273402.11322.17.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438273402.11322.17.camel@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 05:23:22PM +0100, Matt Fleming wrote:
> On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> > Moved the function of transferring EFI status to kernel error for
> > later used by EFI stub.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  drivers/firmware/efi/vars.c | 33 ---------------------------------
> >  include/linux/efi.h         | 33 +++++++++++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+), 33 deletions(-)
> 
> The patch contents are fine but the title could do with some work,
> "public" isn't a verb. I think "Make efi_status_to_err() public" would
> be fine.
>

Thanks for your correcting, I will change the patch title.

Joey Lee 
