From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 0/8] efi: add support for non-standard capsule headers
Date: Tue, 18 Apr 2017 17:26:50 +0100
Message-ID: <f417e914-7b95-9886-fb8f-bca79d5456a3@nexus-software.ie>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405092317.27921-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 05/04/17 10:23, Ard Biesheuvel wrote:
> This is a followup to Jan's series [0] to add support for the non-standard
> and awkward capsule header layout that is used by the Quark platform.
>
> While we would prefer to adhere to the standard rigorously, the reality
> (and common practice) in Linux is that we sometimes have to deal with
> quirks. So while Jan's aim is to get Quark to work, the reason for my
> involvement is to try and accommodate this in a flexible way without
> putting any handling specific to this quirk in the common code.

Hi Ard, Jan.

I've run this series on my Galileo Gen2 and it appears to work well.

Please take my;

Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>

for the series.

---
bod
