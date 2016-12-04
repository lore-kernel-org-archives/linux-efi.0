From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 0/2] Honey, I shrunk the EFI stub
Date: Sun, 4 Dec 2016 14:13:34 +0000
Message-ID: <20161204141334.GK20785@codeblueprint.co.uk>
References: <cover.1478510356.git.lukas@wunner.de>
 <20161112205514.GA2373@codeblueprint.co.uk>
 <20161114111906.GA9938@wunner.de>
 <20161114153231.GB10141@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161114153231.GB10141-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 14 Nov, at 04:32:31PM, Lukas Wunner wrote:
> 
> Oh the info_sz variable *is* already initialized to 0 before the first
> invocation of GetInfo().  So the patch should be fine, reviewed it
> once more with the explanations in mind that you provided and couldn't
> see anything else that would cause issues in mixed-mode.

Thanks for double-checking that. These patches look good to me and
pass all my testing. Queued for v4.11, thanks Lukas!
