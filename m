From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap
 section
Date: Thu, 9 Mar 2017 17:13:40 -0500
Message-ID: <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
References: <20170306220348.79702-1-thgarnie@google.com>
 <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com>
 <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri
List-Id: linux-efi@vger.kernel.org


>> I don't have any experience with Xen so it would be great if virtme can test it.
>
> I am pretty sure I tested this series at some point but I'll test it again.
>


Fails 32-bit build:


/home/build/linux-boris/arch/x86/kvm/vmx.c: In function ‘segment_base’:
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: ‘host_gdt’
undeclared (first use in this function)
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: (Each undeclared
identifier is reported only once
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: for each
function it appears in.)
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
‘int’ in declaration of ‘type name’
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
‘int’ in declaration of ‘type name’
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: initialization
from incompatible pointer type
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: unused
variable ‘gdt’


-boris

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
