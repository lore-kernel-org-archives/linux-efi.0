From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap section
Date: Thu, 9 Mar 2017 14:31:49 -0800
Message-ID: <CAJcbSZEnUBfLHjf+bHqY0JQhQXD9urX45BXrQjx=1=A5gPpp_w@mail.gmail.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com> <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com> <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Cooper <andrew.cooper3@citrix.com>, Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Dave
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 9, 2017 at 2:13 PM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
>
>>> I don't have any experience with Xen so it would be great if virtme can=
 test it.
>>
>> I am pretty sure I tested this series at some point but I'll test it aga=
in.
>>
>
>
> Fails 32-bit build:
>
>
> /home/build/linux-boris/arch/x86/kvm/vmx.c: In function =E2=80=98segment_=
base=E2=80=99:
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: =E2=80=98host_gdt=
=E2=80=99
> undeclared (first use in this function)
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: (Each undeclared
> identifier is reported only once
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: for each
> function it appears in.)
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
> =E2=80=98int=E2=80=99 in declaration of =E2=80=98type name=E2=80=99
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
> =E2=80=98int=E2=80=99 in declaration of =E2=80=98type name=E2=80=99
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: initialization
> from incompatible pointer type
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: unused
> variable =E2=80=98gdt=E2=80=99
>
>
> -boris

It seems that I forgot to remove line 2054 on the rebase. My 32-bit
build comes clean but I assume it is not good enough compare to the
full version I build for 64-bit KVM testing.

Remove just this line and it should build fine, I will fix this on the
next iteration.

Thanks for testing,

--=20
Thomas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
