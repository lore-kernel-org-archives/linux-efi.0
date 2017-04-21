From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 03/11] cper: add timestamp print to CPER status
 printing
Date: Fri, 21 Apr 2017 20:12:21 +0200
Message-ID: <20170421181221.4qqfprbyljgv4ekb@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-4-git-send-email-tbaicar@codeaurora.org>
 <20170421122150.76cce2cfrt767glv@pd.tnic>
 <35cc4ae0-e8fa-fd3a-5d7f-243ed2e82ea0@codeaurora.org>
 <20170421172603.4574wonnm5tgvbcn@pd.tnic>
 <a20143dc-8daa-102b-d929-4d96f73353e3@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <a20143dc-8daa-102b-d929-4d96f73353e3@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawe
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 21, 2017 at 12:08:43PM -0600, Baicar, Tyler wrote:
> The timestamp may still be useful when it is imprecise. In the polling case,
> you may only poll every minute or so, so the time may be useful.

Well, what is in the timestamp when !precise? Some random time or some
timestamp from a couple of seconds ago? How do you differentiate what
timestamp is bollocks and what is from a while ago?

Is the imprecise tstamp really close to the time the error happened or
pointing at 1970 - the beginning of unix time? :-)

I'm sure you've picked up by now that we don't trust the firmware one
bit.

> Also, I imagine there could be interrupt based errors happening much faster than the
> FW/OS handshake can happen. Maybe we can just use what I had before but also
> specify imprecise so that it is clear:
> 
>         printk("%s%ststamp: %02d%02d-%02d-%02d %02d:%02d:%02d\n", pfx,
>             (timestamp[3] & 0x1 ? "precise " : "imprecise "),
>              century, year, mon, day, hour, min, sec);

I guess.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
