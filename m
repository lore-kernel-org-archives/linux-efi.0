From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace
 in secure boot case
Date: Wed, 7 Nov 2012 23:27:22 +0000
Message-ID: <20121107232722.67589868@pyramind.ukuu.org.uk>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352323699-52400-1-git-send-email-trenn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed,  7 Nov 2012 22:28:17 +0100
Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org> wrote:

> Hi,
> 
> I have seen some patches in this area and I wonder whether MSR and EC write accesses from userspace got closed already.

You need to cover read accesses as well I suspect to be completely
paranoid safe. I would also look at MTRRs because mis-setting MTRRs
allows you to get firmware to do interesting things in certain situations
because the commands being issued to stuff like the GPU may get corrupted.

Alan
