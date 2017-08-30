From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/14] EFI capsule update support for IOT2000 devices
Date: Wed, 30 Aug 2017 20:31:12 +0100
Message-ID: <CAKv+Gu8yOpzY4sb2YNE30+NLTa9BqTQdQqvUNPXABnV7v++RgQ@mail.gmail.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com> <CAKv+Gu9k94FZbakSZz3VtXPr+e921q=m6OkeYiJ-4y0OhT2-Pw@mail.gmail.com>
 <93fd99e5-da27-49cc-86af-b9b8c4db1f6a@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <93fd99e5-da27-49cc-86af-b9b8c4db1f6a-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>, cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, stable@
List-Id: linux-efi@vger.kernel.org

On 30 August 2017 at 20:27, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> On 2017-08-30 21:24, Ard Biesheuvel wrote:
>> Hello Jan,
>>
>> On 30 August 2017 at 20:13, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>>> Last chunk: This backports EFI capsule updates, primarily for the use
>>> with the IOT2020 and IOT2040, the latter with Quark-proprietary security
>>> header format. The feature should also work for the Galileo Gen 2 and,
>>> at least conceptually, for any EFI capsule update compatible firmware.
>>>
>>
>> What is the purpose of this series? I hope you are not expecting this
>> to be considered for -stable?
>> Please check Documentation/process/stable-kernel-rules.rst for
>> guidelines on what is appropriate for -stable.
>
> Argh, sorry. Missed that I didn't activate the CC filter for this one.
>
> Everyone except for Ben and cip-dev, please ignore - this is just a
> backport to the CIP SLTS kernel.
>

OK no worries
