From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Mon, 30 Sep 2013 16:46:42 -0400
Message-ID: <20130930204642.GB6116@redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
 <20130930203505.GA6116@redhat.com>
 <20130930204154.GE19411@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130930204154.GE19411@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 30, 2013 at 10:41:54PM +0200, Borislav Petkov wrote:

[..]
> hpa, so, for the struct efi_mapping thing to work, I will have to grep
> dmesg of the first kernel to get an output like the one below, filter
> the runtime regions so that I can build the struct efi_mapping array of
> mem regions which I pass on to the second, kexec kernel with setup_data.

Any data you need to pass to second kernel will have to be exported to
user space either using /sys or /proc so that kexec-tools can parse it.

Thanks
Vivek
