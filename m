Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16C93E172F;
	Wed,  8 Jul 2026 07:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783494962; cv=none; b=iPFaMr8PHAQWIVRwxi2BaA5PDk4ArpClrQTv3RcLSW3dOnCMOXaHPALR9PbLmiRWAt1L6QLigUckC6xwGKOFQUv/W5XarmIov8WMAsaPRSw9qz/tTIOWL4tEvZlHv+OQ9Prja+p+CoPi0mz4jI38rJtO+6vuDwLZQZF//jwW0Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783494962; c=relaxed/simple;
	bh=VWmWh6pzki/ShXejJu251uuQUSOrl8ApE+ih5NcCoSk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ft7tamZ4AjWYzboe7LrDx/w0YiKWyMcJyFNSNP2gCcluY2aGDvYVuIRbm71/cs71QS16dsZb3Ne8znNcz97bZWUXTUqSnI5KqTWw0Zj1ZO2oT6q8w+a/EHzrgE04ZKS7K0WeX4yOu0BXcJTzVoArPZk8RmRE8PEjKCDdKYQdvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYDWuUEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYDWuUEd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6EDFC2BCF4;
	Wed,  8 Jul 2026 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783494960;
	bh=VWmWh6pzki/ShXejJu251uuQUSOrl8ApE+ih5NcCoSk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HYDWuUEd+swZZpJ5jxAfUsBbCQmJs9mkezhp4PvoaTS5uFeidGbF9ovIrS1N2XKiM
	 EkHAacBP5AOykWFH1bizsQnkn7NZUa06lj6Qb6bAvsNuvds1AaP3oNT/MbiPV6BGxm
	 R8lGD+trNsNhfOfmRFfYW3eSF4qVhiAWNACZwx6Hi9ab0Ufj8pRyHpR2RbOYX6GlPr
	 vh1ZYuv5uzpmPNngcEUIFtuWVcnB+qbS+uCQsT4xtxfCJtXWJWQ06mS9k5Qf1NjuoY
	 iUWH9MvQ6E+mKBRF9Nxgfjjxi6mLcYxYfCcVXbd78mbXYC99MW+vwZTU91M4rORMUm
	 4W+zCTsYGGjTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E65C43602;
	Wed,  8 Jul 2026 07:16:00 +0000 (UTC)
From: Sven Peter <sven@kernel.org>
Date: Wed, 08 Jul 2026 09:15:37 +0200
Subject: [PATCH RFC 1/6] dt-bindings: arm: psci: Add EFI conduit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-efi-psci-v1-1-9efb3abf0e4c@kernel.org>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
In-Reply-To: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@kernel.org>, Janne Grunau <j@jannau.net>, 
 Neal Gompa <neal@gompa.dev>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
 asahi@lists.linux.dev, Sven Peter <sven@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1948; i=sven@kernel.org;
 h=from:subject:message-id;
 bh=VWmWh6pzki/ShXejJu251uuQUSOrl8ApE+ih5NcCoSk=;
 b=owGbwMvMwCXmIlirolUq95LxtFoSQ5bvT40an+LrNSsz3ou+eHBk0ZXtj533ymnX23xwvt15x
 YdfqJ65o5SFQYyLQVZMkWX7fnvTJw/fCC7ddOk9zBxWJpAhDFycAjCRg5qMDCvvckRZqXWc3Cb2
 W/IGc2WwDau3kNEPx6YTR8vSMlbsDGdkuPHeUvnjNHez9BTjI6zrxY8f0638FyfOeFRiqa7irW9
 LOAE=
X-Developer-Key: i=sven@kernel.org; a=openpgp;
 fpr=A1E3E34A2B3C820DBC4955E5993B08092F131F93
X-Endpoint-Received: by B4 Relay for sven@kernel.org/default with
 auth_id=407

Apple Silicon machines run the kernel in the highest available exception
level and can't trap to anything higher for PSCI calls. Instead, we will
add support for a conduit based on EFI runtime services to be able to
share the same level with the kernel itself.
Add the conduit to the bindings.

Signed-off-by: Sven Peter <sven@kernel.org>
---
 Documentation/devicetree/bindings/arm/psci.yaml | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/psci.yaml b/Documentation/devicetree/bindings/arm/psci.yaml
index 6e2e0c551841..f9d607e1a213 100644
--- a/Documentation/devicetree/bindings/arm/psci.yaml
+++ b/Documentation/devicetree/bindings/arm/psci.yaml
@@ -28,6 +28,14 @@ description: |+
   Note that the immediate field of the trapping instruction must be set
   to #0.
 
+  Alternatively, when the "efi" method is used, the PSCI functions are not
+  invoked by trapping to a higher privilege level. Instead, they are backed
+  by EFI runtime services: the firmware exposes a PSCI handler that the OS
+  invokes through an EFI runtime call. This method is intended for platforms
+  where the kernel runs at the highest privilege level, leaving no higher level
+  to trap into; the firmware shares that same level and is instead reached
+  through EFI runtime services.
+
   [2] Power State Coordination Interface (PSCI) specification
     http://infocenter.arm.com/help/topic/com.arm.doc.den0022c/DEN0022C_Power_State_Coordination_Interface.pdf
 
@@ -69,6 +77,10 @@ properties:
       - smc
       # HVC #0, with the register assignments specified in this binding.
       - hvc
+      # The PSCI functions are implemented by EFI runtime services, and are
+      # invoked through a runtime call into the firmware rather than via an
+      # SMC or HVC trap.
+      - efi
 
   cpu_suspend:
     $ref: /schemas/types.yaml#/definitions/uint32

-- 
2.55.0


