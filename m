From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many
 entries to nvram.
Date: Mon, 18 Nov 2013 19:07:20 +0000
Message-ID: <20131118190720.GA20875@srcf.ucam.org>
References: <87fvr3h3b9.fsf@redhat.com>
 <20131111110701.GE22636@console-pimps.org>
 <87eh6nt8oo.fsf@redhat.com>
 <20131113112052.GJ22636@console-pimps.org>
 <878uws1msy.fsf@redhat.com>
 <20131113140647.GK22636@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131113140647.GK22636@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 13, 2013 at 02:08:14PM +0000, Matt Fleming wrote:

> OK, it looks like the firmware Boot Manager gets very confused when it
> tries to parse the Boot Load Option you created with efibootmgr. This
> looks like a general firmware bug and not something we need to worry
> about in the kernel.

Well, we do do some parsing of the boot parameters in the kernel in 
order to avoid hitting a Tianocore bug. But if the problem is just that 
the Dell firmware falls over if it sees something that isn't Unicode, I 
don't think we can really work around that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
