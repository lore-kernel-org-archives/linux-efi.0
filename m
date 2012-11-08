From: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace in secure boot case
Date: Thu, 8 Nov 2012 10:40:33 +0100
Message-ID: <201211081040.33981.trenn@suse.de>
References: <1352323699-52400-1-git-send-email-trenn@suse.de> <20121107215403.GA7277@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121107215403.GA7277-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wednesday, November 07, 2012 09:54:03 PM Matthew Garrett wrote:
> Is there a case where modifying MSRs or EC registers can cause arbitrary
> code execution?

Ok, I am not familiar enough with this secure stuff.
Theoretically writing EC registers could be used to trick ACPI
code and change the way it is processed by inspecting ACPI
code for bad EC register return values.

Similar for MSR, the kernel could be (not directly) influenced
by setting MSR registers in a way it does not expect them to be.

I expect it's easy to get the system totally stalled/hang/rebooted
with bad MSR writes which I thought should be forbidden for
userspace (even for root...) in secure boot mode.

   Thomas
