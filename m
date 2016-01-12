From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 1/2] ia64: split off early_ioremap() declarations
 into asm/early_ioremap.h
Date: Tue, 12 Jan 2016 21:33:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FAC179@ORSMSX114.amr.corp.intel.com>
References: <1452604966-9905-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452604966-9905-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org" <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Yu, Fenghua" <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> So create a <asm/early_ioremap.h> for ia64, and move the existing
> definitions into it.

These look OK.

Acked-by: Tony Luck <toy.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


Can you put them into the same tree where the pending breakage is sitting?
Then I don't have to worry about coordinating pull requests from the ia64
tree.

-Tony
