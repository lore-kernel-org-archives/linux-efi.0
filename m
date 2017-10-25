From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Wed, 25 Oct 2017 16:18:31 +0200
Message-ID: <f70a8042-463d-09c8-65f9-9d07f71b84a2@suse.cz>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
 <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
 <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg@mail.gmail.com>
 <9dfcee94-2058-8986-526c-f7ef9ebada66@suse.cz>
 <CAKv+Gu9S0w0EUvruDjruR+hJ0B2QU_do1GknV83C8CgLTp8T2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9S0w0EUvruDjruR+hJ0B2QU_do1GknV83C8CgLTp8T2Q@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-Id: linux-efi@vger.kernel.org

On 10/06/2017, 04:01 PM, Ard Biesheuvel wrote:
> On 6 October 2017 at 13:53, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 10/04/2017, 09:33 AM, Ard Biesheuvel wrote:
>>> In arm64, we use ENTRY/ENDPROC for functions with external linkage,
>>> and the bare symbol name/ENDPROC for functions with local linkage. I
>>> guess we could add ENDOBJECT if we wanted to, but we never really felt
>>> the need.
>>
>> Yes and this is exactly the reason for the new macros. Now, it's a
>> complete mess. One arch does this, another does that. And we are in a
>> state to have reliable stacktraces, let objtool check functions, let
>> objtool generate annotations (e.g. for ORC unwinder), etc.
>>
> 
> You are implying that ENTRY/ENDPROC and 'bare symbol name'/ENDPROC
> prevent you from doing any of this, but this is simply not true.

If I understand correctly, you have not read the discussion behind the
link I sent you... So in sum:
Initially, I only used the current ENTRY/ENDPROC approach and augmented
it to fix up the mess in x86. But it was concluded that these old macros
are terrible and we rather want to avoid them. It was especially the bad
naming of these old macros. So we discussed what the new naming scheme
could be and this is what we ended up with.

>> Without knowing what is start, where is its end, what is function, what
>> is object (data) etc., it can barely check or even generate anything
>> automatically. Not speaking about impaired macros like your name/ENDPROC
>> above.
>>
> 
> What is the problem with impaired macros?

Obviously that they are impaired. That is the tools do not know where to
stop with reading of code or data.

This is quite usual:

foo:
  mov data,a
  call bar
  ret

data: .string "hello"

This makes the tools to choke on the data while thinking it is still code.

> So what is preventing people from using these new macros in the wrong way?

The tools. It is quite easy to check this during build by a linker and I
have such a patch here. It was not yet concluded (I think) whether we
are going to check this via objtool or by something like my patch.
Noteworthy, objtool can check much more in this respect, obviously.

thanks,
-- 
js
suse labs
