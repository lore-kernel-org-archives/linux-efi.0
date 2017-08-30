From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 00/14] EFI capsule update support for IOT2000 devices
Date: Wed, 30 Aug 2017 21:27:08 +0200
Message-ID: <93fd99e5-da27-49cc-86af-b9b8c4db1f6a@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
 <CAKv+Gu9k94FZbakSZz3VtXPr+e921q=m6OkeYiJ-4y0OhT2-Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9k94FZbakSZz3VtXPr+e921q=m6OkeYiJ-4y0OhT2-Pw@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>, cip-dev@lists.cip-project.org, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Denys Vlasenko <dvlasenk@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Salter <msalter@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sam Protsenko <semen.protsenko@linaro.org>, stable@
List-Id: linux-efi@vger.kernel.org

On 2017-08-30 21:24, Ard Biesheuvel wrote:
> Hello Jan,
> 
> On 30 August 2017 at 20:13, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> Last chunk: This backports EFI capsule updates, primarily for the use
>> with the IOT2020 and IOT2040, the latter with Quark-proprietary security
>> header format. The feature should also work for the Galileo Gen 2 and,
>> at least conceptually, for any EFI capsule update compatible firmware.
>>
> 
> What is the purpose of this series? I hope you are not expecting this
> to be considered for -stable?
> Please check Documentation/process/stable-kernel-rules.rst for
> guidelines on what is appropriate for -stable.

Argh, sorry. Missed that I didn't activate the CC filter for this one.

Everyone except for Ben and cip-dev, please ignore - this is just a
backport to the CIP SLTS kernel.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
