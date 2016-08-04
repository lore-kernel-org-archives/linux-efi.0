From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/6] efi: Assign Apple device properties
Date: Thu, 4 Aug 2016 16:52:22 +0100
Message-ID: <20160804155222.GN3636@codeblueprint.co.uk>
References: <cover.1469616641.git.lukas@wunner.de>
 <a0edd928ab099682c2cb4c4544c599573144d03a.1469616641.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a0edd928ab099682c2cb4c4544c599573144d03a.1469616641.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, reverser-P1ImLx+pFc0@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 28 Jul, at 02:25:41AM, Lukas Wunner wrote:
> We've just extended the efistub to retrieve device properties from EFI
> on Apple Macs and stash them in a setup_data payload.

I'd really like to see this patch merged with the EFI boot stub patch,
if possible because it makes for a more cohesive patch (and it'd be
easier to review).
