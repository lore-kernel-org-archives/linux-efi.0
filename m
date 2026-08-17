Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27342253FC
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 05:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786942956; cv=pass; b=Q6iwIsPRxk9/OoyukEkV+hG21P2S+gg3GErR1nISmBpa7EXGdhInf9kNAx6nLMibNlvzJdpIe/ly6AG57rTZLSB6edww2AcR3drk27GPTN0opdicJg2ZJ2dvyizPVlhDHm6Ubr2TmenOyfX3bf9hcm0mBBpBk63uFqGkVOzyF7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786942956; c=relaxed/simple;
	bh=/vnlXw1vg51WClqglYSoXDRtRgD3/bNrYVr/0IH3+kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rg3admtmd19B6c2YzYLvC+21RKbGF3J+WXfo3xtDTvceTkmFPXwKRo6aKhG5ptsibMhkoiOQWr3ylse46yTeHFhSiHTjaGRpNoYNc7lOhFPsKFq2lHzkJ1Un3QPHZg9QgxRHfVckUmma2F5req+ir6iQTH1BrGZGD+yol694N00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b=IDXII/hI; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault.org header.i=@brainfault.org header.b="IDXII/hI"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1722314f8f.3
        for <linux-efi@vger.kernel.org>; Sun, 16 Aug 2026 22:02:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786942953; cv=none;
        d=google.com; s=arc-20260327;
        b=QqYPjeHY+zoOuwtKaUHlu58bK89xgEeUtwS+gbCbqdkWXaWpyATwLe1AEWBkdnRCos
         TWy3RwABCVv3DP/9nnQxKjH+VO9A1U8a6kin+uapee2p0Dbd2gN1hb0F+AqYa/ilJGuL
         JvCxM12poySJjjKuoFYbFq8Et4Gph1ywvbWIRQn/y44EL+bfBOFchUfxxWGn6LmrdhhI
         ozFFC08radWza1mumEoSsVz5rysmPe4yTVsCTibsTlc0yBoIZ5dSYEq6e5sBSxY7GrmS
         /mdkg8osjBw+l1C59Q8wDtnE01obrlMSHrNsSIY7s+76lWkbBeNnGHJHw0YDKZ/BM9YU
         1JLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qoYi18RDSR4LawRHK5O3loQLaPLqT9tLcA3hUir4WQY=;
        fh=K8tV7dmEcjfzk9aF7Jzu4jgp1/wLoiUQjvC6lDQGkOk=;
        b=bpHE2UnLvtJQaKNnlujhsxGyOTA8nNnWvbYup3zco56hRIBVyOAtoOeg33Sqgv5lg+
         ILGSj/g4RzkZoUz1NvOIavRY9HVQaX+ekNuKQFrQG+UrOOyRWAHfZNcCd24lsJhxcvSd
         OPK0NL0OMxsKZaHEufnea/71TsDsXd5Ae+hwQQ/0N4mdFfiZ6ma9b6NzvYGDnRW85mOk
         R7AnJdsm2B2ANRXUV+2Sm+y8WleSo5QWOvesl6VxPPL5YYF7bVCZ+pdRN432ZxH/p/ih
         0cpQmcbtaoswzuaPBNvkakbkej5wyEvVDg1mbj7GGaoeNA4Q7yz+nBlhW/M0bOZP0zJH
         HQKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault.org; s=google; t=1786942953; x=1787547753; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qoYi18RDSR4LawRHK5O3loQLaPLqT9tLcA3hUir4WQY=;
        b=IDXII/hIrYYNBEUqAQ2HC0Sbt6lU1ITMF0ql3R60uq1nSjPl7hmz20sUPdyfLWeiLn
         ga5t0BXPdBLBbOZGwK0mCGzgFKlq53rPIH3PCZe42gAjWRaTFSCJsVKy20+Q/QCOIfDa
         v2AMV4efAPXN1kno3XC3lVW1XPifC4sSDMc1GcXC0G41IEwZMY2azfyuFWi4MABKWVV9
         YkCWkq9z3YGnb3qa4ch41VHOMO5EuY+h/Vd9k/cwf/NKpV22ry5QFS6lMJiltBrCnNp8
         Cq0W6tC6oSp709e9/hRzZr161A+Qd4InYbkuXr7RFXN6BUaed/WeJRfJLz1+yFK/uCav
         6YTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786942953; x=1787547753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qoYi18RDSR4LawRHK5O3loQLaPLqT9tLcA3hUir4WQY=;
        b=nxeJQOgnhdjExqdMQ8/UUhCaybpccL+CSoqqM/v6ywB7PMNVsfobocF5W8ivBvRzAO
         //tSqhdXSxDBtkUZEX1Lx5cIlrbrWWQSOI1pmkY1wPJTcfs3pbyvlRNS9Gq1jRLyYiAC
         DPpZQsTSkmMe4wvqkU7zAUGH3d8BuYrqLa2L2hWbLRVaCUYWSwUbXqtA+AD2d7dfXt9t
         0Lg1ecKOippE55M1ysrPOCryLpuAnVYkbw9j48S/M7xheoPTR9EQrncQ/PiCovcnjIM4
         0Qs0s4n9B6ImNPJA4HQquQaRZLIGLB3oOSFTMhwkUswEcmkwtWJ4pOitKC0DQnd04y+n
         Gkvg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6VB4gDMNa5R5rr8mRGHoViWtp4lT+LEQkVKrld7SltgUke3Pko0Eemb4x797l6q1kP2neLmTzi1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKTv94DTL98dcunPH61JZ2Mo+JL5XACu6oAD/pboyC+uCFxXBx
	SUNXrPfyF5FYnjWQFHhL9MDHnrKok1Vx4bYTqcCXZvzwXR/oMUr01Mb3/gMkVfED+kx2zBzZVVI
	ttMTNUAhJmHFB1on6oI/P2u3RoJRflXNGW0XC5NU9Hw==
X-Gm-Gg: AR+sD13KBzIjh6+KBf2FHFmk3uLeQGNoTaOOjimQDxPEtlIxUSfopy2IYu5XjzeTDQ0
	XD7njfsIEL2RrVAk5pwdAXgEbAeFco9PPvSAscqnuE/dIUiEWrIycRZ/MYxzQoW/heD7eqr4yfO
	yCQZEcn6DLY+Ys4j0dmB8wkwKThz8NQLIkqel8Ck0E/5sjERabu9O4ipR+M9GlZGjlGVioOnfmf
	HXIIQDcGHVoGIwmSo5YFeCo2ybeKb8wcsuq8eGnyCOptsToZvx49vQeFngUhtyQXJ/qQ4XcZq77
	m4ZL++2IUo2ATeNfVA5x80DJFSzyNqhcDkjNdAIL92WWisrSXMpaApZgWdc8CK8wtqK7CbvqkJv
	KE6AGnplGHClvHaffLqK9c5gZYSlEmrZSNMoh6tFbC/DsOikDYtzapuTp0eR6Itc=
X-Received: by 2002:a05:6000:2588:b0:47f:97f6:d39a with SMTP id
 ffacd0b85a97d-48160799ccemr36697191f8f.17.1786942952631; Sun, 16 Aug 2026
 22:02:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-9-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-9-himanshu.chauhan@oss.qualcomm.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Aug 2026 10:32:21 +0530
X-Gm-Features: AcwNN1WIHMlsMJLB7hUwYKC927a3ggaJ6kZFcGlSqz813vIhEHmZTD8KTFxo-cU
Message-ID: <CAAhSdy2LkwC_FBFWP3M66X-mY8WwpSHiOCOKf=e4Fri=gkt27Q@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] riscv: Introduce HEST SSE notification handlers
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, 
	acpica-devel@lists.linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	lenb@kernel.org, james.morse@arm.com, tony.luck@intel.com, ardb@kernel.org, 
	conor@kernel.org, cleger@rivosinc.com, robert.moore@intel.com, 
	sunilvl@oss.qualcomm.com, anup.patel@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 2:18=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> Add config option to enable SSE in APEI. When it is enabled, functions
> to register/unregister a ghes entry with SSE are avilable along with
> low and high priority event handers. If a SSE notification type is
> determined, a ghes common handler to handle an error event is registered.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  drivers/acpi/apei/Kconfig |  5 ++
>  drivers/acpi/apei/ghes.c  | 99 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 93 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index 428458c623f0..895a843d0e36 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -46,6 +46,11 @@ config ACPI_APEI_SEA
>         depends on ARM64 && ACPI_APEI_GHES
>         default y
>
> +config ACPI_APEI_SSE
> +       bool
> +       depends on RISCV && RISCV_SBI_SSE && ACPI_APEI_GHES
> +       default y
> +
>  config ACPI_APEI_MEMORY_FAILURE
>         bool "APEI memory error recovering support"
>         depends on ACPI_APEI && MEMORY_FAILURE
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 8edc2c8db1bb..1baa8ddd10ea 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -17,6 +17,8 @@
>   *   Author: Huang Ying <ying.huang@intel.com>
>   */
>
> +#include <linux/err.h>
> +#include <linux/riscv_sbi_sse.h>
>  #include <linux/arm_sdei.h>
>  #include <linux/kernel.h>
>  #include <linux/moduleparam.h>
> @@ -100,6 +102,11 @@
>  #define FIX_APEI_GHES_SDEI_CRITICAL    __end_of_fixed_addresses
>  #endif
>
> +#ifndef CONFIG_RISCV_SBI_SSE
> +#define FIX_APEI_GHES_SSE_LOW_PRIORITY __end_of_fixed_addresses
> +#define FIX_APEI_GHES_SSE_HIGH_PRIORITY        __end_of_fixed_addresses
> +#endif
> +
>  static ATOMIC_NOTIFIER_HEAD(ghes_report_chain);
>
>  static inline bool is_hest_type_generic_v2(struct ghes *ghes)
> @@ -1662,6 +1669,63 @@ static int apei_sdei_unregister_ghes(struct ghes *=
ghes)
>         return sdei_unregister_ghes(ghes);
>  }
>
> +#if defined(CONFIG_ACPI_APEI_SSE)
> +/* SSE Handlers */
> +static int __ghes_sse_callback(struct ghes *ghes,
> +                              enum fixed_addresses fixmap_idx)
> +{
> +       if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
> +               irq_work_queue(&ghes_proc_irq_work);
> +
> +               return 0;
> +       }
> +
> +       return -ENOENT;
> +}
> +
> +/* Low priority */
> +static int ghes_sse_lo_callback(u32 event_num, void *arg, struct pt_regs=
 *regs)
> +{
> +       static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sse_lo);
> +       struct ghes *ghes =3D arg;
> +       int err;
> +
> +       raw_spin_lock(&ghes_notify_lock_sse_lo);
> +       err =3D __ghes_sse_callback(ghes, FIX_APEI_GHES_SSE_LOW_PRIORITY)=
;
> +       raw_spin_unlock(&ghes_notify_lock_sse_lo);
> +
> +       return err;
> +}
> +
> +/* High priority */
> +static int ghes_sse_hi_callback(u32 event_num, void *arg, struct pt_regs=
 *regs)
> +{
> +       static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sse_hi);
> +       struct ghes *ghes =3D arg;
> +       int err;
> +
> +       raw_spin_lock(&ghes_notify_lock_sse_hi);
> +       err =3D __ghes_sse_callback(ghes, FIX_APEI_GHES_SSE_HIGH_PRIORITY=
);
> +       raw_spin_unlock(&ghes_notify_lock_sse_hi);
> +
> +       return err;
> +}
> +
> +static int apei_sse_register_ghes(struct ghes *ghes)
> +{
> +       return sse_register_ghes(ghes, ghes_sse_lo_callback,
> +                                ghes_sse_hi_callback);
> +}
> +
> +static int apei_sse_unregister_ghes(struct ghes *ghes)
> +{
> +       return sse_unregister_ghes(ghes);
> +}
> +#else /* CONFIG_ACPI_APEI_SSE */
> +static int apei_sse_register_ghes(struct ghes *ghes) { return -EOPNOTSUP=
P; }
> +static int apei_sse_unregister_ghes(struct ghes *ghes) { return -EOPNOTS=
UPP; }
> +#endif
> +
>  static int ghes_probe(struct platform_device *ghes_dev)
>  {
>         struct acpi_hest_generic *generic;
> @@ -1708,6 +1772,14 @@ static int ghes_probe(struct platform_device *ghes=
_dev)
>                 pr_warn(GHES_PFX "Generic hardware error source: %d notif=
ied via local interrupt is not supported!\n",
>                         generic->header.source_id);
>                 goto err;
> +       case ACPI_HEST_NOTIFY_SSE:
> +               if (!IS_ENABLED(CONFIG_ACPI_APEI_SSE)) {
> +                       pr_warn(GHES_PFX "Generic hardware error source: =
%d notified via SSE is not supported\n",
> +                               generic->header.source_id);
> +                       rc =3D -EOPNOTSUPP;
> +                       goto err;
> +               }
> +               break;
>         default:
>                 pr_warn(FW_WARN GHES_PFX "Unknown notification type: %u f=
or generic hardware error source: %d\n",
>                         generic->notify.type, generic->header.source_id);
> @@ -1775,6 +1847,17 @@ static int ghes_probe(struct platform_device *ghes=
_dev)
>                 if (rc)
>                         goto err;
>                 break;
> +
> +       case ACPI_HEST_NOTIFY_SSE:
> +               rc =3D apei_sse_register_ghes(ghes);
> +               if (rc) {
> +                       pr_err(GHES_PFX "Failed to register for SSE notif=
ication on vector %d\n",
> +                              generic->notify.vector);
> +                       goto err;
> +               }
> +               pr_err(GHES_PFX "Registered SSE notification on vector %d=
\n",
> +                      generic->notify.vector);

This needs to be pr_info() instead of pr_err().

> +               break;
>         default:
>                 BUG();
>         }
> @@ -1804,7 +1887,6 @@ static int ghes_probe(struct platform_device *ghes_=
dev)
>
>  static void ghes_remove(struct platform_device *ghes_dev)
>  {
> -       int rc;
>         struct ghes *ghes;
>         struct acpi_hest_generic *generic;
>
> @@ -1838,16 +1920,11 @@ static void ghes_remove(struct platform_device *g=
hes_dev)
>                 ghes_nmi_remove(ghes);
>                 break;
>         case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
> -               rc =3D apei_sdei_unregister_ghes(ghes);
> -               if (rc) {
> -                       /*
> -                        * Returning early results in a resource leak, bu=
t we're
> -                        * only here if stopping the hardware failed.
> -                        */
> -                       dev_err(&ghes_dev->dev, "Failed to unregister ghe=
s (%pe)\n",
> -                               ERR_PTR(rc));
> -                       return;
> -               }
> +               apei_sdei_unregister_ghes(ghes);
> +               break;
> +
> +       case ACPI_HEST_NOTIFY_SSE:
> +               apei_sse_unregister_ghes(ghes);
>                 break;
>         default:
>                 BUG();
> --
> 2.43.0
>
>

Regards,
Anup
