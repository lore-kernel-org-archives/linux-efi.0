Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBE04915B5
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369526; cv=pass; b=FWZsl9dCYLUQCA0kOe7AD+bPc4fdLiH0tjOO4oyM25IaoGEs0WHR95f9EgqzRwRYzdTGh0ehFemqjpmIgB+34MBqqC5d2k5LTXX4GwO2upDfZPYWblFADnWHHveM28BbHflHvwHW/k8crU7V61awL9xh1gjDStEvDowLTSqDZu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369526; c=relaxed/simple;
	bh=mtJBgn6in8wzem2JAyNu6wrzK0bRyVrRNtx68bFbips=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=os/sj7daNXMmFBiNn28FkI2W1K6R0KBSLUaitToLJgtl9QgKvah+MqNKymWeTkQmrzu5t51T9jJUm0l2pr0VdezDe4Q6RCfuIie+4QSD40svYnnBEgAP9bvy7wGn1qQvYtjbux6yQVQFYssRNxtz41ke5vxtU0jeeHgdo8/iU/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=WQ7eOzq2; arc=pass smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="WQ7eOzq2"
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 611403FCF0
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 10:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791369481;
	bh=cmc54HmmpdHlv+8/JD67MSRGD2aOFG6+FX+TpShyqMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=WQ7eOzq20Nzp+h3jDEZpRb4PVOuQtPJawnIGpB19S76AMZogXAPIfskw5UZM84YQP
	 MbAgx9s1gBi6gQgiRxNj1fwOaPiXGfKj8KaDh/0+9li2OlQ0CzHWvP1PUcfd3xqHla
	 VX+YAe2t3uYDdgwgW1UoIkteFAdNuzeoAi5a009tDwnuvgeT+RFzRLf0qgOc7sjDq9
	 zt1MPKrN3XCitGx2TL3QIygT+qKaMiEakSwe/V7ZaqNzIrS4RyXxFC/m17nqUWeA/H
	 DT0l+QsashCz5QiRFX5C2g1FRsXVDejj0RgRAy5E926PyCX5gjswwbtKm4snP/QikK
	 8tGPsG9kXJNYvYiIUWD8ETnuuZPaFWAl/XkK+KOxY1b2HLqSVvk/FubHX7N6yGbzz1
	 GL7PXx1V4ginarhNdpBBD1iBWeUTQ1Ew9SveusL2QA0BA0Z4HYpllSPFkUwcmDepqM
	 W7FZIcNQV99jiMj0SLdES2MKhSiXihhGyvV3LJoMqzwxcEspl9v4/F7Qy5mbT1iEDh
	 G+fPUcI6UQmK1yE/pduIchLw3OAkpiSdvb42lHgSJAFgctGMeNHNbihTP/L+5eqmf9
	 4xBYuRrcV0ZFFtP5ZccJt+/mr8QfNcES3YOKuFafwoLySfQjlfn7TccJqEYGtFQZuk
	 Csn9nK6drLET4uF6OhiRkXcA=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2e7daa588bso136178966b.0
        for <linux-efi@vger.kernel.org>; Wed, 07 Oct 2026 03:38:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791369481; cv=none;
        d=google.com; s=arc-20260327;
        b=D22ZHwCIw++CnBMTuiC4Ys2tOmERkpe9Ow8jgMrmIAzizFKIAyJ5fWAma0lE5m+c3V
         uUCGay8G7qdPmFwGIloFlKFckCCjJZyMZIkACYIya/0EqzzYqQcb5LunD+tZp0Yg/PnV
         zOlPv2h9fUCeBEHKN89ptKNJRP84VDZK3n4EmVOeGeRGHI82/Ubhf9rOHsvhsgXvEmeY
         eGhvu8rvrwGAdVCmKiOK9T2jGcRByM2TVnhzN5FRnUmeBRgdGjLQbpsW+ofjQaV065Yc
         Em/+uSL1QEG9caihD9XHTIzfuiSADTFujfhQORemZWBYOFdl4Mzg6T5fmftIpaHAe6cT
         eo5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=cmc54HmmpdHlv+8/JD67MSRGD2aOFG6+FX+TpShyqMo=;
        fh=Yg4lC43asEXlnQ7Cwe+Q3q6lj3ONFYxEC0PVRw4T4Wo=;
        b=KSTs1WRlK//wJTlLViXCMliGiHXmgAZo2WCzkzoPfYIZo8TqvIjV03IzOEvh576UUz
         /qm0ipidltKaaNW1VJmB+itUb8bsgTikkZV/6v9/nS5dKlU6vjEHhnIsBOm98Ktcq7Ni
         gcFGft5JmJ3rHXDinPqaXrwMKWqrFhHnsVVVKtTHTD3ypTuiJotuATXxs1lqGRLVkikB
         IpPEyDmqcWt0GljI7Z9SdKbx3qfZ+SQ3vJrjrE1Oemz1v5DtqdeACPhDYxBoI4UuifEo
         weu8coTsPDqfVcC+rGZFppW5uALVZLK298VLzdttiS9Ta+2rSu6hz92sNArrA0ZmD8zT
         ap8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791369481; x=1791974281;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cmc54HmmpdHlv+8/JD67MSRGD2aOFG6+FX+TpShyqMo=;
        b=AMWWPqGWP3mHa/vgmOFyMURHZewEpYBaHhnisQFGicJ72ubCD2NUTu0VWOkdad4H45
         25YWPVZ7g6OKZo1hF0XSa9FcvLWPF6GyRQVYombaw9r1jpOXCI9SWcDpuCg8yK1JH9Zw
         aohkHOEsSBQeqkseNf0IS0nJX9+mSIrGO1tg2goEenUALwcFgGsihtsu3VWEHXrd4o8N
         /xXGP12N39BTfhoeIUVmB2Q7aNPRDCXx53/r06ZD+RHrdIh6dz5SavrCYmX8Kz/vcLDL
         0UEdCVnUH4/m+zUErOOPPwr1fiTnKjA5njxYB3EwKJJoaH7k0r55Kg8RItJaWvIvN9Fk
         aFQg==
X-Forwarded-Encrypted: i=1; AKwUvByXrytzbFwf2nbnrNsgJCDtHB4pi1GZcOv6DBWlXXEATuZuTUbQ+NLrSdMFtEJMHbgoHXg2k8waBhY=@vger.kernel.org
X-Gm-Message-State: AFuF++kOy4wSI/Ppt6ISyjXu0r0z1AnCb2Uo8rj37tza6WXK2LJzgbr5
	vS23xcWHxOjrUSkv0AKFLDETUlCY89uU6JpXG9AcIC9UcoOdP26S3Gdr4xa662o4HJby2mXuq8C
	/H/OaPUYyd29fW0AqO1c2KaR026En+qjTjUWTPO3sa0KzBkoTVI0DrIfXY5fxetK45NihRsblAh
	CKd1gsmRdAqPQMsR6YFEGY5fjhKFa7uE7pf1rqx9RoyWKxqMuc6Edb
X-Gm-Gg: AYBFou2dHL7G/tFtWvcRVNkFjk3QnfrrnEmzbfuKxtOdoj2WIUGHH0zzCCRVcFGb6SY
	YZx0zkqnKlf03g0ywdYB+RQnSWwxzT3dL++aSQ4yK2AHwbi2UXsBdrgddsZ8JakBdNiwiL/ql05
	gazLz0jJvPH4qu9X0yGG/IbgCXXThNroq7+QYAY7dkm8sByKbPwQiI9MYO5Id11PJnQ5j7SBWU9
	IBIaGzLktvvfWu84w==
X-Received: by 2002:a17:907:720a:b0:c2e:4b90:3c55 with SMTP id a640c23a62f3a-c317bb32151mr185464666b.5.1791369480956;
        Wed, 07 Oct 2026 03:38:00 -0700 (PDT)
X-Received: by 2002:a17:907:720a:b0:c2e:4b90:3c55 with SMTP id
 a640c23a62f3a-c317bb32151mr185463666b.5.1791369480593; Wed, 07 Oct 2026
 03:38:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250625-more-qseecom-v4-0-aacca9306cee@oss.qualcomm.com> <20250625-more-qseecom-v4-7-aacca9306cee@oss.qualcomm.com>
In-Reply-To: <20250625-more-qseecom-v4-7-aacca9306cee@oss.qualcomm.com>
From: Tobias Heider <tobias.heider@canonical.com>
Date: Wed, 7 Oct 2026 12:37:47 +0200
X-Gm-Features: AclHuK8eKzgj3HJdIk9MQwD1iZnSbhGYtbY2krS3CF9VuPiN8gJrqeCrxO3qntA
Message-ID: <CAARv3RQ2-Cnr-Zu_57cz4bBOaNVji14cGQo5eGB7QXjBjEwofQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] firmware: qcom: scm: rework QSEECOM allowlist
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, Maximilian Luz <luzmaximilian@gmail.com>, 
	Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Johan Hovold <johan@kernel.org>, Steev Klimaszewski <steev@kali.org>, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-efi@vger.kernel.org, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

I think making the list more generic would be great. Currently onboarding n=
ew
devices always requires a kernel/driver rebuild on top of the device-tree w=
hich
isn't ideal. If we could allow all of sc8280xp, x1e80100 and glymur by defa=
ult
adding new devices to our Ubuntu images would be a lot easier.

Since this seems to have stalled a while ago I was wondering if you
had any plans to
continue this work. Is there a technical reason this never went anywhere?

- Tobias

On Wed, Jun 25, 2025 at 12:55=E2=80=AFAM Dmitry Baryshkov
<dmitry.baryshkov@oss.qualcomm.com> wrote:
>
> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>
> Listing individual machines in qcom_scm_qseecom_allowlist doesn't scale.
> Allow it to function as allow and disallow list at the same time by the
> means of the match->data and list the SoC families instead of devices.
>
> In case a particular device has buggy or incompatible firmware user
> still can disable QSEECOM by specifying qcom_scm.qseecom=3Doff kernel
> param and (in the longer term) adding machine-specific entry to the
> qcom_scm_qseecom_allowlist table.
>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> ---
>  drivers/firmware/qcom/qcom_scm.c           | 49 ++++++++++++++----------=
------
>  include/linux/firmware/qcom/qcom_qseecom.h |  1 +
>  2 files changed, 24 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qco=
m_scm.c
> index 5bf59eba2a863ba16e59df7fa2de1c50b0a218d0..025f834e95b537b76d41b59b6=
3871a4ce5bed717 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -1981,6 +1981,7 @@ int qcom_scm_qseecom_app_send(u32 app_id, void *req=
, size_t req_size,
>  }
>  EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_send);
>
> +static unsigned long qcom_qseecom_disable =3D QCOM_QSEECOM_QUIRK_DISABLE=
;
>  static unsigned long qcom_qseecom_ro_uefi =3D QCOM_QSEECOM_QUIRK_RO_UEFI=
VARS;
>
>  static char *qseecom =3D "auto";
> @@ -1989,32 +1990,20 @@ module_param(qseecom, charp, 0);
>
>  /*
>   * We do not yet support re-entrant calls via the qseecom interface. To =
prevent
> - * any potential issues with this, only allow validated machines for now=
. Users
> + * any potential issues with this, only allow validated platforms for no=
w. Users
>   * still can manually enable or disable it via the qcom_scm.qseecom modp=
aram.
> + *
> + * To disable QSEECOM for a particular machine, add compatible entry and=
 set
> + * data to &qcom_qseecom_disable.
>   */
>  static const struct of_device_id qcom_scm_qseecom_allowlist[] __maybe_un=
used =3D {
> -       { .compatible =3D "asus,vivobook-s15" },
> -       { .compatible =3D "asus,zenbook-a14-ux3407qa" },
> -       { .compatible =3D "asus,zenbook-a14-ux3407ra" },
> -       { .compatible =3D "dell,xps13-9345" },
> -       { .compatible =3D "hp,elitebook-ultra-g1q" },
> -       { .compatible =3D "hp,omnibook-x14" },
> -       { .compatible =3D "huawei,gaokun3" },
> -       { .compatible =3D "lenovo,flex-5g" },
> -       { .compatible =3D "lenovo,thinkpad-t14s" },
> -       { .compatible =3D "lenovo,thinkpad-x13s", },
>         { .compatible =3D "lenovo,yoga-c630", .data =3D &qcom_qseecom_ro_=
uefi, },
> -       { .compatible =3D "lenovo,yoga-slim7x" },
> -       { .compatible =3D "microsoft,arcata", },
> -       { .compatible =3D "microsoft,blackrock" },
> -       { .compatible =3D "microsoft,romulus13", },
> -       { .compatible =3D "microsoft,romulus15", },
> -       { .compatible =3D "qcom,sc8180x-primus" },
> +       { .compatible =3D "qcom,sc8180x", },
> +       { .compatible =3D "qcom,sc8280xp", },
>         { .compatible =3D "qcom,sc8280xp-crd", .data =3D &qcom_qseecom_ro=
_uefi, },
> -       { .compatible =3D "qcom,x1e001de-devkit" },
> -       { .compatible =3D "qcom,x1e80100-crd" },
> -       { .compatible =3D "qcom,x1e80100-qcp" },
> -       { .compatible =3D "qcom,x1p42100-crd" },
> +       { .compatible =3D "qcom,sdm845", .data =3D &qcom_qseecom_disable,=
 },
> +       { .compatible =3D "qcom,x1e80100", },
> +       { .compatible =3D "qcom,x1p42100", },
>         { }
>  };
>
> @@ -2046,12 +2035,22 @@ static bool qcom_scm_qseecom_machine_is_allowed(s=
truct device *scm_dev,
>         match =3D of_match_node(qcom_scm_qseecom_allowlist, np);
>         of_node_put(np);
>
> -       if (match && match->data)
> +       if (!match) {
> +               dev_info(scm_dev, "qseecom: untested machine, skipping\n"=
);
> +               return false;
> +       }
> +
> +       if (match->data)
>                 *quirks =3D *(unsigned long *)(match->data);
>         else
>                 *quirks =3D 0;
>
> -       return match;
> +       if (*quirks & QCOM_QSEECOM_QUIRK_DISABLE) {
> +               dev_info(scm_dev, "qseecom: disabled by the quirk\n");
> +               return false;
> +       }
> +
> +       return true;
>  }
>
>  static void qcom_scm_qseecom_free(void *data)
> @@ -2086,10 +2085,8 @@ static int qcom_scm_qseecom_init(struct qcom_scm *=
scm)
>
>         dev_info(scm->dev, "qseecom: found qseecom with version 0x%x\n", =
version);
>
> -       if (!qcom_scm_qseecom_machine_is_allowed(scm->dev, &quirks)) {
> -               dev_info(scm->dev, "qseecom: untested machine, skipping\n=
");
> +       if (!qcom_scm_qseecom_machine_is_allowed(scm->dev, &quirks))
>                 return 0;
> -       }
>
>         /*
>          * Set up QSEECOM interface device. All application clients will =
be
> diff --git a/include/linux/firmware/qcom/qcom_qseecom.h b/include/linux/f=
irmware/qcom/qcom_qseecom.h
> index 8d6d660e854fdb0fabbef10ab5ee6ff23ad79826..d48044ece20cc9ebac3357a64=
2dc671c349d4343 100644
> --- a/include/linux/firmware/qcom/qcom_qseecom.h
> +++ b/include/linux/firmware/qcom/qcom_qseecom.h
> @@ -52,5 +52,6 @@ static inline int qcom_qseecom_app_send(struct qseecom_=
client *client,
>  }
>
>  #define QCOM_QSEECOM_QUIRK_RO_UEFIVARS         BIT(0)
> +#define QCOM_QSEECOM_QUIRK_DISABLE             BIT(1)
>
>  #endif /* __QCOM_QSEECOM_H */
>
> --
> 2.39.5
>
>
