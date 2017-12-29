From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [RFT PATCH] efi: capsule-loader: reinstate virtual capsule
 mapping
Date: Fri, 29 Dec 2017 03:09:52 +0000
Message-ID: <35d1f2df-88e1-cb43-9488-e3cad896869a@nexus-software.ie>
References: <20171226132142.3254-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171226132142.3254-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> So we need to fix this without breaking Quark. Fortunately, Quark does
> not appear to care about the virtual mapping, and so we can simply
> do a partial revert of commit 2a457fb31df6 ("efi/capsule-loader: Use
> page addresses rather than struct page pointers"), and create a vmap()
> mapping of the entire capsule (including header) based on the reinstated
> struct page array, unless running on Quark, in which case we pass the
> capsule header copy as before.


Working on the Galileo (Quark x1000 non-secure) Ard. I've tested a 
capsule with and without the quirk header so it should work on the 
secure part too.

Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>

---
bod
