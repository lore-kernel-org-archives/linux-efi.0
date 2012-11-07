From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace
 in secure boot case
Date: Wed, 7 Nov 2012 23:21:33 +0000
Message-ID: <20121107232133.12f94cfe@pyramind.ukuu.org.uk>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
	<20121107215403.GA7277@srcf.ucam.org>
	<509AE5DA.1030508@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509AE5DA.1030508-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Nov 2012 23:51:06 +0100
"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:

> On 11/07/2012 10:54 PM, Matthew Garrett wrote:
> > Is there a case where modifying MSRs or EC registers can cause arbitrary 
> > code execution?
> 
> For MSRs we could have a whitelist of permitted MSRs, but allowing
> general MSR access... no.

Far safer to just block it and expect people to use MSRs accessed via
drivers that provide functionality. Otherwise your blacklist in some
cases will get fiendishly complicated and sometimes depend upon the exact
chip and the values in other MSRs as to whether they are safe.

Alan
