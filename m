From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Thu, 18 Aug 2016 21:41:30 +0100
Message-ID: <20160818204130.GQ30909@codeblueprint.co.uk>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
 <20160815125643.GG30909@codeblueprint.co.uk>
 <20160817054413.GB5498@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160817054413.GB5498@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Icenowy Zheng <icenowy@aosc.xyz>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Josh Boyer <jwboyer@redhat.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-efi@vger.kernel.org

On Wed, 17 Aug, at 01:44:13PM, Dave Young wrote:
> 
> Could we add some quirk for these broken hardware instead of changing
> the normal code?

I'd prefer not to do that if possible. Due to the way that the BIOS
ecosystem works, this kind of broken firmware spreads across the
industry, appearing in newer versions of products from the same vendor
and even products from different vendors.

Continuously updating a quirks table as additional broken platforms
are discovered simply does not scale.
