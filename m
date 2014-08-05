From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Add efi= parameter parsing to the EFI boot stub
Date: Tue, 5 Aug 2014 17:17:00 +0100
Message-ID: <20140805161700.GS15082@console-pimps.org>
References: <1407245008-2994-1-git-send-email-matt@console-pimps.org>
 <CAKv+Gu8bpU9D8MrsLSF=j_HDwcctjFEyvHnB2FPeAP-j77RKjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8bpU9D8MrsLSF=j_HDwcctjFEyvHnB2FPeAP-j77RKjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Aug, at 05:51:13PM, Ard Biesheuvel wrote:
> 
> Seems to work fine, both with and without efi=nochunk, when reading a
> DTB padded to 16 megabytes.
> 
> Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Great, thanks for testing Ard.

-- 
Matt Fleming, Intel Open Source Technology Center
