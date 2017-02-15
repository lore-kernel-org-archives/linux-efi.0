From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V8 08/10] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Wed, 15 Feb 2017 12:03:42 -0500
Message-ID: <20170215120342.48eff95d@gandalf.local.home>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
        <1485969413-23577-9-git-send-email-tbaicar@codeaurora.org>
        <20170215105234.4921db1f@gandalf.local.home>
        <e50b7673-a441-3a6b-cf75-c267881c1a92@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <e50b7673-a441-3a6b-cf75-c267881c1a92@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, S
List-Id: linux-efi@vger.kernel.org

On Wed, 15 Feb 2017 09:54:09 -0700
"Baicar, Tyler" <tbaicar@codeaurora.org> wrote:
\
> 
> In v9 I currently have this and the ARM trace event from this series 
> both wrapped in an
> ifdef verifying that CONFIG_RAS is enabled. This resolves the kbuild 
> failures and
> will have this code compiled out when that config isn't enabled. Do you 
> think I
> should use the ifdef or use these *_enabled() functions?
> 

I believe you need both. The *_enabled() functions wont prevent build
errors. But since tracing is seldom enabled (usually only when you want
to see what's happening), the *_enabled() functions optimize the code
to not perform tasks that are only needed when tracing is enabled. When
I say "enabled" I mean actively tracing, as supposed to being just
enabled in the kernel.

-- Steve
